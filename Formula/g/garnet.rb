class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "2914c54299af3b36f83ec1323e9bbfc5de40c62b0c47938fb336660bf33db1d7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80b375787af7c7a623a96b77b4af3dbb218111ae27775c10a3d6d7713fc14efd"
    sha256 cellar: :any,                 arm64_sequoia: "0b754eddebf1c78854a9e653cb087c5d975ec89428a1c9eff47d0f6da0ce8c31"
    sha256 cellar: :any,                 arm64_sonoma:  "07bbd7dad78e4b0536cec52a0f7c7d8dda8057c5d673cc7d4510f910311b9ff2"
    sha256 cellar: :any,                 sonoma:        "6556aa4a7f46a770942a9c2f7eb15d9626fec9189c8e563bb1f21d3b73879a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b282748d51c5a1a2f33fd5850a7902760d6c5e518876820ce2ba3de7bf34fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d617558546bd9b067c44f6d594a355a176918a6c648f76221f126e093a1338"
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
