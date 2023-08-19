class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.1.8.tar.gz"
  sha256 "6fe1371558cdfae21c45ff70a8b3ed3c80fda29df27ac5851b3a2d42e8fd2d9e"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "bbc48b0e8c17b3c56a9950a69c3f953ff46dd3aae76b75c2d1e333c82c3d9344"
    sha256                               arm64_monterey: "47f5929c59f802ee0c54255f1a199e95c715cfd13d650409d34be9202043c48e"
    sha256                               arm64_big_sur:  "1ecf4ddb3274cb760b9d4c14b93d11519a7ec2c751a8d9fa7d577efec7f90785"
    sha256                               ventura:        "ce0f768b6c539a796ae8bca17dd3eae68322f7530525890d642e9e3074b56965"
    sha256                               monterey:       "1d8547e8b3f5c484b272394314623deaf1e1f40198df96173c4ede71bf9804ae"
    sha256                               big_sur:        "39a29d65f45e1cf56f91256b0b9ba130b4376ae7519363c2789dbfb395007912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a944f1784477a517deb85271f22b11d28cbbcde4df73d834faef788231b0d8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
