class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.98.tar.gz"
  sha256 "9e74ccc845e8d840c52b453598b86f277528fe8c617ec30e8bcb3c2a597c118c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c2b17d5f83017bbae066d7f272aa50552aa2c49a370a5726210b692971c7c4c"
    sha256 cellar: :any,                 arm64_sequoia: "a62de60a74988b275f62893cb72b9fec711b186fee19a2f2914e79bd5508b220"
    sha256 cellar: :any,                 arm64_sonoma:  "42051e0373d5ee5e8882507cfd837041d6519d1828bb64690a55e87588726282"
    sha256 cellar: :any,                 sonoma:        "b3f8b20c6d44329aee38cc2053c322f93f2ebf22ec396f374831b56bd10cac48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f44a9dded74bf812ef3b8401513c84b9e5a840467ee081a84ad6de35172e80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f139ef054cb2d5df01bf9993f9071c8975b14b1cd14a6a54258d65a0b7ba0ed"
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
