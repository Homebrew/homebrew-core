class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/s/ddd/"
  url "https://ftp.gnu.org/gnu/ddd/ddd-3.3.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/ddd/ddd-3.3.12.tar.gz"
  sha256 "3ad6cd67d7f4b1d6b2d38537261564a0d26aaed077bf25c51efc1474d0e8b65c"
  license all_of: ["GPL-3.0-only", "GFDL-1.1-or-later"]
  revision 1

  bottle do
    rebuild 2
    sha256 monterey:     "93fa51898f3e60c09d6baf1696799a89fac8fed798a4c6dac0321b1b8518dd6b"
    sha256 big_sur:      "498ceb2dc933d2c85e7407f077d187c6cd799ba2f539694087134d038bb211d9"
    sha256 catalina:     "df163eb838675a73c69913af1e1526a5c20e5cbeafa58836112ce4ae642a705a"
    sha256 mojave:       "ef4ae2c46be3ad1aee12c52ca34d7606c3aa056250792a61c03af4581fe8e568"
    sha256 high_sierra:  "9fc9c568178424aeb25d6721c4faffb99a8bd7ef967ea0ae4e3464b65651d0b8"
    sha256 x86_64_linux: "b77e99734dc952ce417d949ba92e03e138f8f4b1a8224a4e3a98bc2822cea7b8"
  end

  depends_on "gdb" => :test
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  # https://savannah.gnu.org/bugs/?41997
  patch do
    url "https://savannah.gnu.org/patch/download.php?file_id=31132"
    sha256 "f3683f23c4b4ff89ba701660031d4b5ef27594076f6ef68814903ff3141f6714"
  end

  # Patch to fix compilation with Xcode 9
  # https://savannah.gnu.org/bugs/?52175
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/a71fa9f4/devel/ddd/files/patch-unknown-type-name-a_class.diff"
    sha256 "c187a024825144f186f0cf9cd175f3e972bb84590e62079793d0182cb15ca183"
  end

  # Patch to fix compilation with Xt 1.2.0
  # https://savannah.gnu.org/patch/?9992
  patch do
    url "https://savannah.gnu.org/patch/download.php?file_id=50229"
    sha256 "140a1493ab640710738abf67838e63fbb8328590d1d3ab0212e7ca1f378a9ee7"
  end

  def install
    if OS.linux?
      # Patch to fix compilation error
      # https://savannah.gnu.org/bugs/?33960
      # Remove with next release
      inreplace "ddd/strclass.C", "#include <stdlib.h>", "#include <stdlib.h>\n#include <cstdio>"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-builtin-app-defaults",
                          "--enable-builtin-manual",
                          "--prefix=#{prefix}"

    # From MacPorts: make will build the executable "ddd" and the X resource
    # file "Ddd" in the same directory, as HFS+ is case-insensitive by default
    # this will loosely FAIL
    system "make", "EXEEXT=exe"

    ENV.deparallelize
    system "make", "install", "EXEEXT=exe"
    mv bin/"dddexe", bin/"ddd"
  end

  test do
    output = shell_output("#{bin}/ddd --version")
    output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
    assert_match version.to_s, output
    assert_match testpath.to_s, pipe_output("#{bin}/ddd --gdb --nw true 2>&1", "pwd\nquit")
  end
end
