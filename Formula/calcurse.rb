class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.5.0.tar.gz"
  sha256 "c372ef16abcacb33a1aca99d0d4eba7c5cc8121fa96360f9d6edc0506e655cee"
  head "https://git.calcurse.org/calcurse.git"

  bottle do
    sha256 "a8d96452549f69d900bdaa33145ddd7e7d0ebe11c303c4daec93825fae9d60f1" => :mojave
    sha256 "73e2230461c906cea1e065ef512da4f7b82d1fba230da5122f0c7c875e2a6c41" => :high_sierra
    sha256 "4f09d52ffd027cb13e73473fa5d01ad9a22aa985e0aa3e3d195df2e5b92f30e0" => :sierra
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
