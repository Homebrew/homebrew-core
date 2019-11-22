class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.5.1.tar.gz"
  sha256 "5336576824cba7d40eee0b33213992b4304368972ef556a930f3965e9068f331"
  head "https://git.calcurse.org/calcurse.git"

  bottle do
    sha256 "8e9e4538d02408549659f6eb7512a8f9fdd9d2c38369967bd5d9aba67519e7d9" => :catalina
    sha256 "2b88932ea815161ce2a1d9af1d8e56612aea158255e991246b0da92e1fe11365" => :mojave
    sha256 "9318cecc6785ff6ac34439793e88a904eebafd9c7fd84d543157ffb6a405cf18" => :high_sierra
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
