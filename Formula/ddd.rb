class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/s/ddd/"
  url "https://ftp.gnu.org/gnu/ddd/ddd-3.3.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/ddd/ddd-3.3.12.tar.gz"
  sha256 "3ad6cd67d7f4b1d6b2d38537261564a0d26aaed077bf25c51efc1474d0e8b65c"
  license all_of: ["GPL-3.0-only", "GFDL-1.1-or-later"]
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "a2d1ceeadc2055223cea7c3e3776393dfc01bd0f2946ed82dda8226fe11ccb29" => :catalina
    sha256 "41917b105d1329eaa9421fe314e449fca4c9b9f27b5c4a2ad10d0dbb746a8cea" => :mojave
    sha256 "381ae07c96a67534b05a03ca72741d99aa3437a01c0fef603336ea218c470df9" => :high_sierra
    sha256 "af12e95b5b4326906236559a40f6715e896d164d5c18d9448384e0e22d089abf" => :sierra
    sha256 "68864faf1967b400bc5df5809ab9ee03a0d632f3736071131dd5469be715c58f" => :el_capitan
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
    assert_match testpath.to_s, shell_output("printf pwd\\\\nquit | #{bin}/ddd --gdb --nw true 2>&1")
  end
end
