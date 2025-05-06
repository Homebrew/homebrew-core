class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.63.tar.gz"
  sha256 "50806ab9ac54bde5f4ec3bbd9d125fe76c727050d304d1189907f7bea7e88df3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8fe34fed471728b7e7b958a12324f6cdaf1c824191aa378fb1773de336e21d21"
    sha256 cellar: :any,                 arm64_sonoma:  "0d701d5dcafe8774431acfba5a54733d6aaed83414d7893c66b689ded3ada1b4"
    sha256 cellar: :any,                 arm64_ventura: "bf80041ae13fd77feca8a1059353e867bcbd3ae7c7cf74b31d7622ebda3d77a3"
    sha256 cellar: :any,                 ventura:       "fa993148492fd29fcfcb60204bf1f387da426bb499bd5ec8245ed52037d02199"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2897019ca88b8bd47434b59de71c170258793a803ee31164152deb4477abad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad716cc5a8c5d1cd585bce48c942998e59dad6927ec9cd6f0a4a70711ef5ce4"
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
