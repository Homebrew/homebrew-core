class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.0.62.tar.gz"
  sha256 "1d6e0669711a8d8940b1d71b2b0329998eb42964ceda2da2cd39d40149bea029"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "190aab6aa93a9edea3de2a2303389d0f0b3bb9698984db4aea4f82caf6cd75c7"
    sha256 cellar: :any,                 arm64_sonoma:  "e366be7de7d0ca4ed2d972fe1f4bda467b0054c83453707c84a29108228063ef"
    sha256 cellar: :any,                 arm64_ventura: "f8b72c3a5670250c2f6b0f3a5ad363d98b98c781de9da03ad7bf71ae4b5bc21f"
    sha256 cellar: :any,                 ventura:       "5fd93c4b9a57a4153784ba6e3e1ad149458da4933d74fa1b2c6025a1272de2a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d33930bf668c676b98ef646bcb160699006f4c29e89eebada650095b48072d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "031dd827ccd878300db89e9caadd1df7377b9742bad40069fce53586545d49ee"
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
