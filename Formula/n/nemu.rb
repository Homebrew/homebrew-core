class Nemu < Formula
  desc "Ncurses UI for QEMU"
  homepage "https://github.com/nemuTUI/nemu"
  url "https://github.com/nemuTUI/nemu/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "f35b7e5c534bae294fe6df7685b686682145222a954b6914dfdcc17d386fecba"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_ventura:  "4c10435792d5708eef1a8fd5d1aa504616a0387f3b66e069a99d6084cd7a97ea"
    sha256 arm64_monterey: "9a5b94e574734ff942ceef51f3c47ac203a53f636be78e2ab560d1c82dfe40cf"
    sha256 arm64_big_sur:  "d6afaec948bdd9ef2db37ac4844e0131ad12daac732f6903818760679d8334f4"
    sha256 ventura:        "427ed14c86065271bb18f07d4c2c409d2c24f325c4d73d63563d14cd15376910"
    sha256 monterey:       "129e2d494fd094a2dd72c4aecd8ae11f8d78492fa9b03aa35fecdb1a378cfa89"
    sha256 big_sur:        "acf4c11eae2001ce5332a1492711a60fe29ac879a64b15f576b968ad96bf3a19"
    sha256 x86_64_linux:   "3b8b5991992a53932c6cc20fcd8cceb88394ff091602ab715f0ae8a0d7ac8f0d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libusb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = /^Config file .* is not found.*$/
    assert_match expected, pipe_output("XDG_CONFIG_HOME=#{Dir.home} #{bin}/nemu --list", "n")
  end
end
