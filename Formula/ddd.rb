class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/s/ddd/"
  url "https://ftp.gnu.org/gnu/ddd/ddd-3.3.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/ddd/ddd-3.3.12.tar.gz"
  sha256 "3ad6cd67d7f4b1d6b2d38537261564a0d26aaed077bf25c51efc1474d0e8b65c"
  revision 1

  bottle do
    sha256 "c37e9851b799befc425280b8e62e2c7b12dc79ecf46eaed9e740f9e2ef87d373" => :sierra
    sha256 "0effedf657591027f917ea1dd048e32e136da61490ba64a51e1b8dddad17acdf" => :el_capitan
    sha256 "9753fcc17d509faf60b8566da742c8eaaefc2e52e5d360366b6fa827a61c733b" => :yosemite
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
