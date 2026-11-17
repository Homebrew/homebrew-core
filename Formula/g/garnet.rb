class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v2.2.13.tar.gz"
  sha256 "3a6616b044b199c6b798dc34e16a6cbca34567de8f6520fc9cfafb8169fe8015"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1594447aff185207e52f78ef9bbbc320c1bacff5cec4a3f56570c8323a7b8937"
    sha256 cellar: :any, arm64_tahoe:       "a146bc893c19e0c2d568b3055b82b4344a5ffbda506af75162068bc618e60c9e"
    sha256 cellar: :any, arm64_sequoia:     "434a87822bd64dfc0b374104ce45f7285330cbd96f136d7be91c30f85b1b2c10"
    sha256 cellar: :any, arm64_linux:       "d5a95bb47da1d25f646eebefb755bb2bf5764af0144f325b08a3857d0fd74f1b"
    sha256 cellar: :any, x86_64_linux:      "e7dfc6e591ea16a434441c60158273fce6dfba7db932249eabda9b64e88abbe6"
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
