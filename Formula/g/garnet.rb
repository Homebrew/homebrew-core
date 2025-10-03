class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.84.tar.gz"
  sha256 "b0f6c8b4b6ac9ddd3b10d7bdb6230ef7c08d2bc3a6c88ae489ec8e230e62bc11"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37c3fe53d204c859e88c33218b2922498aec3a94207aaa3c709e08c48bcb10c8"
    sha256 cellar: :any,                 arm64_sequoia: "0c786cdfff3e1b4c075c6c1ee8083483277115b8ceb5383da60c5d56495dab71"
    sha256 cellar: :any,                 arm64_sonoma:  "cc67fd76f14aed6b56ffe9878a740c080eadd1327d276dbb3df10b101962770e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8808f44bb9f2c211d7165e8d2ff60d8928400cbfbf3a2a11dc4b5fbb6fb77db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6171df6f1e44d96372eb2cdae0124f7b3b578728b66eca7edd977aa70bf5fb17"
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
