class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "875bc444a6491d4460b01a011eff5f2a6157b7e126c6ad748cd292b2a035fc58"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba18fb4eaef108e4825c02e0ec017a7ca03e5d395ecd14bb487180e7efd78f90"
    sha256 cellar: :any, arm64_tahoe:       "222a2ce4638d2efcc8a47b275f9ccab8345e595361d9a06692cfed618576bae2"
    sha256 cellar: :any, arm64_sequoia:     "92e75cc1ffa3266396968911146acb8ddb302444481a191824b4f814f7e9f133"
    sha256 cellar: :any, arm64_linux:       "dc6c63c1f41a96a9cfab7670a0b49bd85d5964198b50c7e5811f34e8dbd56ef3"
    sha256 cellar: :any, x86_64_linux:      "c710e3eedde1fdb43adffaf2a1ff700b53b611fb924d8e316d412b6189c77359"
  end

  depends_on "rust" => :build
  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  allow_network_access! :test

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

    system "dotnet", "restore", "main/GarnetServer/GarnetServer.csproj",
                                "--use-current-runtime",
                                "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
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
