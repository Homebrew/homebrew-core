class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v2.2.12.tar.gz"
  sha256 "3612acc1f1dfcaa3e97def393a408b7ccd071cdd2c1b375389bdf42f537c0648"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef8249ad7859d6be0c70a63ce51baf6a2042b590a03f56a8f3dfcbaef8ab435a"
    sha256 cellar: :any, arm64_tahoe:       "b5131cffa7ed33a05ca22d45b49cdf90fe9a38a6e90cebe332b5f7ec61e8ba4a"
    sha256 cellar: :any, arm64_sequoia:     "80ab3f9e48400b6708fb80384fc94f2d338f3f0757c9c0967118f3ef3ee9d5e0"
    sha256 cellar: :any, arm64_linux:       "4c1788f6cca34016cb0f551f303260d8701181309e279b8a0d5289bf4e16cb53"
    sha256 cellar: :any, x86_64_linux:      "966712c9d5012f0c39e9bff11fbe5e9ef031331e5a80b4aae8299a0bb62050b6"
  end

  depends_on "rust" => :build
  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  # Keep using Garnet's stream adapter when .NET defines the same type name.
  patch do
    url "https://github.com/microsoft/garnet/commit/3b7fa55c398b396d6eaf26c8b22df57d2475936a.patch?full_index=1"
    sha256 "5ac2fdce31dc5e47add3694993459c287f5dece20c26d951185ed3e5cefac26c"
    type :unofficial
    resolves "https://github.com/microsoft/garnet/pull/2385"
  end

  allow_network_access! :test

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

    # Restore the same framework and single-file analyzer dependencies used by publish.
    system "dotnet", "restore", "main/GarnetServer/GarnetServer.csproj",
                                "--use-current-runtime",
                                "-p:TargetFrameworks=net#{dotnet.version.major_minor}",
                                "-p:PublishSingleFile=true"
    cd "libs/native/bftree-garnet" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    # Drop the prebuilt BfTree binaries; msbuild rebuilds the library with cargo and prefers its copy
    rm_r Dir["libs/native/bftree-garnet/runtimes/*"]

    # The device csproj ships every prebuilt runtime it finds, so drop the ones we can't use
    native_rid = ("linux-#{Hardware::CPU.arm? ? "arm64" : "x64"}" if OS.linux?)
    device_runtimes = buildpath/"libs/storage/Tsavorite/cs/src/core/Device/runtimes"
    device_runtimes.each_child { |rid| rm_r(rid) if rid.basename.to_s != native_rid }

    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        args = %w[
          -DUSE_URING=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
        system "cmake", "--build", "build"
        native_dir = device_runtimes/native_rid/"native"
        cp "build/libnative_device.so", native_dir/"libnative_device.so"
        cp "build/libnative_device.so", native_dir/"libnative_device_libaio.so"
      end
    end

    # .NET 10 flags IL3000 here even though Garnet falls back to AppContext.BaseDirectory.
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
      -p:WarningsNotAsErrors=IL3000
      -p:EnableSourceLink=false
      -p:EnableSourceControlManagerQueries=false
    ]
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos

    # Remove non-native library
    rm libexec/"liblua54.so" if OS.linux? && Hardware::CPU.arm?
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{formula_opt_bin("valkey")}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end
