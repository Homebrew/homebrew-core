class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.7.0.tar.gz"
  sha256 "ef6675966a53f41196006ce624ece222fe400da0563f4fed1ae0272ad45c8435"
  license "BSD-2-Clause"
  head "https://git.calcurse.org/calcurse.git"

  bottle do
    sha256 "880bc4dc68e7e8e7ffe83313d01ee8ef7b33f883f899d68cb030af739601d99c" => :catalina
    sha256 "70508c51a1f448e13a75fdcab3a85b4cb3c1dc104d62335c32262a0e80fd72f7" => :mojave
    sha256 "02c93d56af71b2272798dea09ce629ba271bda4afaf7965f8fdc00a5a91774d7" => :high_sierra
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
