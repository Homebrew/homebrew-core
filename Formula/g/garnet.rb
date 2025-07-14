class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.77.tar.gz"
  sha256 "da98a12d0d299470c41c59a7d0cad2ea7b4496c479a051a9fdb26ab4a8a69d6a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8fe5312f669d717990f2e95a3ed9437f7f2d83204e9406d2562520274a15fa34"
    sha256 cellar: :any,                 arm64_sonoma:  "3ed050e67a3cc015018ee3ff055e315e77c08af1713a29395a2ed9d841ff733a"
    sha256 cellar: :any,                 arm64_ventura: "5f7d834464a4b39beff00db371cba22848a0c12e135fa1e0c5b5c79db3e690be"
    sha256 cellar: :any,                 ventura:       "0ff97ce70e50301b6692ecd240791cdace46482a54dc6984ec9815de7104a1df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297aafe81bc3b8e6977bb282889132551b508f4bde7a8ff28178af5090ab1bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b1d7c2e4b3ddd93b2413aa60b6bef571107d628409bda00322e23f6d2f24cf"
  end

  depends_on "valkey" => :test
  depends_on "dotnet"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
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
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:EnableSourceLink=false
      -p:EnableSourceControlManagerQueries=false
    ]
    system "dotnet", "publish", "main/GarnetServer/GarnetServer.csproj", *args
    (bin/"GarnetServer").write_env_script libexec/"GarnetServer", DOTNET_ROOT: dotnet.opt_libexec

    # Replace universal binaries with their native slices.
    deuniversalize_machos
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
