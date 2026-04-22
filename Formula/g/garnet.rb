class Garnet < Formula
  desc "High-performance cache-store"
  homepage "https://microsoft.github.io/garnet/"
  url "https://github.com/microsoft/garnet/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "cca16e06df6e018576d75e24c9760a283317d8ac0c60a20928acf8821925b363"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a50bea64c958cd4bf558add28335722ffb54da8c62b5426885f90fd0998dbc8c"
    sha256 cellar: :any,                 arm64_sequoia: "d54866d8c572980df5ebbfcd4a9b9086eec74291a1c618b27607116fe07f4567"
    sha256 cellar: :any,                 arm64_sonoma:  "68eb70d7764c83aa8224a6c43f612f18c8307e95c8cf62423b8643b104be180b"
    sha256 cellar: :any,                 sonoma:        "87d494ce0f67dd6401044b3e3b1785accc8283370cbb95f0f46ba9201c883088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5b57a554a21d15f5abbf7466ee88c2403b45adcc1f22a736b03fe29da5ad0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "108d9b1da7be9aa32c8ec0b0d28c2e6f00f1620175298f3685f2bd1e58e9231e"
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
