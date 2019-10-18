class Calcurse < Formula
  desc "Text-based personal organizer"
  homepage "https://calcurse.org/"
  url "https://calcurse.org/files/calcurse-4.5.0.tar.gz"
  sha256 "c372ef16abcacb33a1aca99d0d4eba7c5cc8121fa96360f9d6edc0506e655cee"
  head "https://git.calcurse.org/calcurse.git"

  bottle do
    sha256 "246b45c9315fe11ab9ef726684282e8fa18929e4c6a4bbb0e48a757754be8f77" => :catalina
    sha256 "738613d3eef794062e61163897d5d7b66c7420221f386fa9614d44d6389d0dae" => :mojave
    sha256 "b1334c12ada2d1aab070efa8d61c93cbc4f3e2a6ad1b5ad61513279c128782d4" => :high_sierra
    sha256 "8da520260dc4b5612d5b9e2a83497e1227a0126195692b48d0842f971df904dd" => :sierra
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
