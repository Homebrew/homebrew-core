class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.1.tar.bz2"
  sha256 "efc20361d6e43f9ff74de5f4d86c2ce9c677693f5da08b0a88d603b7475a508d"

  bottle do
    cellar :any
    sha256 "7a644799cdb284d66951f6244fa224a209a853996a06b79cab6eb3628ac86718" => :sierra
    sha256 "1867e211c3161ea4060c3c0cf65b2017e85d3079b41512948b4c7273870e5712" => :el_capitan
    sha256 "f997aadedf26546b3e11ccab753145bb645e61b49c35e8fbe0bc41bbe5646e57" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                   "-lwpd-0.10", "-I#{include}/libwpd-0.10"
    system "./test"
  end
end
