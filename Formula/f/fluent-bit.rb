class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "1e758df0dec0be3e33f903da1fbcc0f87bd266098147d511ca8d162cbb657576"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "deecc75d498a5afe709df64ed86f5336654fe2134d7a68083ea399fbd63694d8"
    sha256 cellar: :any,                 arm64_sonoma:  "750b80e6df2cf103457f869ec5d8fd894264059f3d4571fc317f6faf2adf02b9"
    sha256 cellar: :any,                 arm64_ventura: "d88906be7d71335c7e9e84be7ab01cdb2a988988268fb465e73e4e35255dff61"
    sha256 cellar: :any,                 sonoma:        "72f6b1fdebacd31f126e594fdaf728c669bb1db9ad7b7049fbb54ed2717552f6"
    sha256 cellar: :any,                 ventura:       "c8ee75e398fea4f5f800e17db6f3e88a5bae5493ecbb05f9a60c85550ebfe98f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf420c22854ed17c308fb7b70d14b5a320dd4a5c245c9569c8a53091ee50436"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
