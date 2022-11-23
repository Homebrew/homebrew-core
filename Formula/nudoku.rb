class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/2.1.0.tar.gz"
  sha256 "eeff7f3adea5bfe7b88bf7683d68e9a597aabd1442d1621f21760c746400b924"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "2235a839fa91c8f417abad05439f67f70d6beb71458e84fe26fbfeefd0dabccf"
    sha256 arm64_monterey: "71845f6de82d5ac9465279ae7f0dc65b580899f321d43e8bd8b2d59b194ebf24"
    sha256 arm64_big_sur:  "daa1278f79f9fdf5cd8780ba68d3bf89982728c1ddf636f89475e89b14bd9c64"
    sha256 ventura:        "ecfe15bec230427b33ea50f132610048b1f9933e4fed347fcc1e51b24bf46c80"
    sha256 monterey:       "a4bc1536b1182fbd0fcd17e64382fe3598bd2ea418a85f76ea809867922faed6"
    sha256 big_sur:        "ec43523a92bb16fadd4ab7fe3f9189cb13849fc3919bf4525b9074a471453745"
    sha256 catalina:       "e6aa92aabc32164b2cc69d55d4a243f6aafdd6d6a109a40339d6546548153174"
    sha256 mojave:         "3afc049f852d205bff4b674e751fb1db83d73ab82ba15e5f38a1ba9c33ffd2e5"
    sha256 x86_64_linux:   "a866bdb43994c69ce7aa6dadc3b50446df14c1daaf4df89bbc095236c80fac07"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
