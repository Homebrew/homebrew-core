class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  # Check for dotnet 10 support on release updates
  # https://github.com/microsoft/garnet/blob/main/Directory.Build.props#L4
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.92.tar.gz"
  sha256 "955877a8e3f6177737aca5237b0f627e9d4d503a0282b9009340e0660f8234d3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6429b48e56443a78082dbbc95fc063fb0a0a6dd34a71ce11c6d75d0d1e4f473a"
    sha256 cellar: :any,                 arm64_sequoia: "793cf6634199e0b2ec3d092bda3875ef7d310f40bacc4de17efa6eb9dec8c41b"
    sha256 cellar: :any,                 arm64_sonoma:  "8d70d83e4446dce8bd5190658d709fb3caac527d39aae2d0e7a3ce2b57830dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908456c13bc5d75db5d8cf9e3119797b27be2e7b7984c74b1612bd8175ff9b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd9cb94dc2599d09b241af849d7c08ade29250972a9493954abd0574606d1053"
  end

  depends_on "valkey" => :test
  depends_on "dotnet@9"

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

    dotnet = Formula["dotnet@9"]
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
