class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.89.tar.gz"
  sha256 "8056ea0271d8dcc4ebed3ffac99c240be2c5450e4e17de44344899194a19cf8a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18f7dc8c6566bea1be1db020ee38add1c3ebcce1be184369b4e34c72f428dad3"
    sha256 cellar: :any,                 arm64_sequoia: "fdd2bb19d20b4ca68a50e409b05d30c27334c17363e93d2782ca5a65675d81f4"
    sha256 cellar: :any,                 arm64_sonoma:  "811d9cbcccf41e1a21ccb522d4a71b8a4a045c629162fef40b91f27a7a209b30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aebe98ed758cf2ce3787f032e66f60bc1f0f4d8fb9eb30ef316f3e14e2c919c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f6c274edde2c80d8c3dc3a7973855bc2e1a71054a1bee0204490efc3ce567a"
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
