class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.59.tar.gz"
  sha256 "69f9addeeea587aa47f2610d82eb9e7b3260ce02d6f9037cedc2a008d0ae031a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "957698c6db789a8511e2eac79413af01cb483a552b9040530ee7f29004af57ce"
    sha256 cellar: :any,                 arm64_sonoma:  "5b8c136f153cf7651e006f8ed7f89f5ef354b8d571674658a4091c61aa6d1969"
    sha256 cellar: :any,                 arm64_ventura: "c86a7e9cde6f6b354b8e2449b7b147a4352b17450ea7e64ba540b52073f710ed"
    sha256 cellar: :any,                 ventura:       "b2e6c8a4310db455e51bf61c02b4a4a9e83ae62b3ac782a5603bb9c902e126c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042c1890436413f79f2f0cef12f00ef24f8cf78f3cb527ba60766d045d8df073"
  end

  depends_on "redis" => :test
  depends_on "dotnet@8"

  on_linux do
    depends_on "cmake" => :build
    depends_on "util-linux" => :build
    depends_on "libaio"
  end

  def install
    if OS.linux?
      cd "libs/storage/Tsavorite/cc" do
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args
        system "cmake", "--build", "build"
        rm "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
        cp "build/libnative_device.so", "../cs/src/core/Device/runtimes/linux-x64/native/libnative_device.so"
      end
    end

    dotnet = Formula["dotnet@8"]
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

    output = shell_output("#{Formula["redis"].opt_bin}/redis-cli -h 127.0.0.1 -p #{port} ping")
    assert_equal "PONG", output.strip
  end
end
