class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.4.0.tar.gz"
  sha256 "edcbc9dbcdfe3aba43ac70b8d6895fb0ff4a364df89762d1ca3053a14cec826f"
  head "https://git.calcurse.org/calcurse.git"

  bottle do
    sha256 "cbbd5f48b6e829ba30d55ee43d171f57494c437685593146774800de8ea4a6d0" => :mojave
    sha256 "dad2aeec1b1ad6a0af16f05a115c71a0ad490d40a8612309c1b7a0501146cb60" => :high_sierra
    sha256 "5e368815101d3bead19d1fd9223073448f06c9acbd329236926b5f0ddb64dbcb" => :sierra
  end

  depends_on "gettext"

  if build.head?
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Specify XML_CATALOG_FILES for asciidoc
    system "make", "XML_CATALOG_FILES=/usr/local/etc/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"calcurse", "-v"
  end
end
