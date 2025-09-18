class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.83.tar.gz"
  sha256 "ed3d11acfae3349df09f5e5c75114b13f78ebfb7453614ad5b9560c9f4c1ec9c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e33df29748a9e3962a2ce98372a698e93f77d17c757a29ef0df4883ae32e1bbc"
    sha256 cellar: :any,                 arm64_sequoia: "cdb35aa0370c4118fcc5ae115cf49e5bcbf8a373d97581745e3f1490d3a33cf9"
    sha256 cellar: :any,                 arm64_sonoma:  "524130174b2a362d5dec3f7344a9ca78c1bd411e2ac9e02681a6539bdf842308"
    sha256 cellar: :any,                 arm64_ventura: "70d740e6c6b31dd16f137a59ba5a8fa199cc1b533584f6ef79738e37b174b756"
    sha256 cellar: :any,                 ventura:       "5ba59ee28099882ca3701fc66205d9cff4f19780eef1541086973313a4a2a932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60ca0e3a0d131c0eee6911b67c8ea1a5f04b404d77b82144b83679084463741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0522745750f292c6ac8cc3fca667ca6a43f769f56fa3c92a03944b730508c75c"
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
