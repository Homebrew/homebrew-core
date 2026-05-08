class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "c6c5ffa68441b6f226053e6c1b6a74f9b951959aef5c9e0a5ace405244bebdb1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06c254e075e022d8a4893c6ed74977542b8240c1cf7abcaaded9997bffdbc19e"
    sha256 cellar: :any,                 arm64_sequoia: "9127622f7a447cf16d1228176bcf456e1d42ed22811dad050c7f18ecd5135b73"
    sha256 cellar: :any,                 arm64_sonoma:  "46bb278aa694a0d3eafa9b82ecfde7a974e3962379bf26b1309745363e1ea9a0"
    sha256 cellar: :any,                 sonoma:        "c758000b5d7d6cabaef59b4fadc25d59c068cdaa6891ffbd4ad9971c6ad689e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4948e08806c463b570190d0ed87760d41cd286fb654b37112fec189cec5bf6e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6473c5f2e0923624ae4d3e970b3af626ea494a116f688030b375534cc32b04a7"
  end

  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        # Fix to cmake version 4 compatibility
        arg = "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
        system "cmake", "-S", ".", "-B", "build", arg, *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
      end
    end

    dotnet = Formula["dotnet"]
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
    port = free_port
    fork do
      exec bin/"GarnetServer", "--port", port.to_s
    end
    sleep 3

    output = shell_output("#{Formula["valkey"].opt_bin}/valkey-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end
