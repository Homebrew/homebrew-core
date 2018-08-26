class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/s/ddd/"
  url "https://ftp.gnu.org/gnu/ddd/ddd-3.3.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/ddd/ddd-3.3.12.tar.gz"
  sha256 "3ad6cd67d7f4b1d6b2d38537261564a0d26aaed077bf25c51efc1474d0e8b65c"
  revision 1

  bottle do
    rebuild 1
    sha256 "41917b105d1329eaa9421fe314e449fca4c9b9f27b5c4a2ad10d0dbb746a8cea" => :mojave
    sha256 "381ae07c96a67534b05a03ca72741d99aa3437a01c0fef603336ea218c470df9" => :high_sierra
    sha256 "af12e95b5b4326906236559a40f6715e896d164d5c18d9448384e0e22d089abf" => :sierra
    sha256 "68864faf1967b400bc5df5809ab9ee03a0d632f3736071131dd5469be715c58f" => :el_capitan
  end

  depends_on "openmotif"
  depends_on :x11

  # Needed for OSX 10.9 DP6 build failure:
  # https://savannah.gnu.org/patch/?8178
  if MacOS.version >= :mavericks
    patch :p0 do
      url "https://savannah.gnu.org/patch/download.php?file_id=29114"
      sha256 "aaacae79ce27446ead3483123abef0f8222ebc13fd61627bfadad96016248af6"
    end
  end

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
  end
end
