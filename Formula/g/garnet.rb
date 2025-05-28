class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.69.tar.gz"
  sha256 "2589cf29e45a48b9d8a4f52489657af3f3268548d13479eeef595b64f87dadeb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "00fd9936f32da5222d5ce179abb7075469c54deb34018bb7faee4c7db2c8b29b"
    sha256 cellar: :any,                 arm64_sonoma:  "0c1fa538bbda5ab6414d354c368c42b5cec96eeda9932c428852b6663ea99303"
    sha256 cellar: :any,                 arm64_ventura: "e7ad03c015f0f40ae0bb2bd5a73795512817e42cf936e08a1adf9dba104c0f72"
    sha256 cellar: :any,                 ventura:       "6bb004c318236974ec6bb70830c594054ad9567d268d79f93f1a4aac045acb77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b03f50390417f7cec0b067e6bcb0b11325a8f091bd12d39b549bacfa3b04136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5637466f74a33d20dcc41f7bdb7bc03506770d794d7f6006a4986421c7618f1b"
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
