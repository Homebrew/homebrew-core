class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "d7bd1fa99103d207dce62734b7208b962f50c2492cdad528d0a442fd86f223df"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0c98d3b4213e94ada829fe28b37735e778a54ef2478f7e8db18619da1e13c7a"
    sha256 cellar: :any,                 arm64_sequoia: "51a82a19fd4521fae5cc50988c784cefdb181735731d355d2560320698ab6edd"
    sha256 cellar: :any,                 arm64_sonoma:  "2c121a86958b1b4a8199c9ee8176e4760499a971c481b7f25fe37c17257b1890"
    sha256 cellar: :any,                 sonoma:        "07b168ab45e10b5124a7e0607526eff687773f9331c457efc71e26d67c11c0fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4af7bc5449ef3eb8f9fb64f5a8f6c57299fb5802430fe1c89d3fcb894b48c4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129fbd5d80544d5a59c15f2592656b8afaa27765aca9e47d8b38b34f1cae4b6e"
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
    # .NET 10 flags IL3000 here even though Garnet falls back to AppContext.BaseDirectory.
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:WarningsNotAsErrors=IL3000
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
