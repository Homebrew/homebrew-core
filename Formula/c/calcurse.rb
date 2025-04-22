class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.8.1.tar.gz"
  sha256 "d86bb37014fd69b8d83ccb904ac979c6b8ddf59ee3dbc80f5a274525e4d5830a"
  license "BSD-2-Clause"

  livecheck do
    url "https://calcurse.org/downloads/"
    regex(/href=.*?calcurse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "22c2e293ade2672fe101d3ce0d0c1522b5b5123ec5fc9675c44c196b43c9ea80"
    sha256 arm64_sonoma:   "a65cd721971bc53914ae926c110cdea2da1a07e56cc39d27baa927c36f6f4934"
    sha256 arm64_ventura:  "06aed9c114caf7eb4c2d9377053a1ad7c38068668073392471776041005fad65"
    sha256 arm64_monterey: "6fa82c03f449fac7c9ac5147bfec928eafc4fb954e8b83237f7dd12ec841ca0f"
    sha256 arm64_big_sur:  "bd80dc2cdaa60bc7c2179ddb040ac4d637e629a62c7e6808cf72d55065c1f38b"
    sha256 sonoma:         "84805e4841bbd1bca3f1a0f940121aeb9545696f634a90addef6dafd21c05f70"
    sha256 ventura:        "42caeb4b9974e324489abd0b2de0b79f32135040d748ef840b14c9d17e3671ff"
    sha256 monterey:       "71ac54ec9a310cb2e1cb76dba48a1805f3d4da56810851b4c1ed01ed5a028905"
    sha256 big_sur:        "34a9d866e4c0a83809187cf84a3248343580ee08c9566a3052e07e61d536fd65"
    sha256 arm64_linux:    "3a8496625aee8af8e440c8f529563d2ddf10b496314d6f5967d4159af4b450e9"
    sha256 x86_64_linux:   "e4b432bb1f32873d100d03212fb03d1a282e3c7a77dc905031ff05513fe0f76a"
  end

  head do
    url "https://git.calcurse.org/calcurse.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
