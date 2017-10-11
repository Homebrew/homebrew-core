class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.2.tar.xz"
  sha256 "323f68beaf4f35e5a4d7daffb4703d0566698280109210fa4eaa90dea27d6610"

  bottle do
    cellar :any
    sha256 "64f3ae80b2deda62803579ee34d72a8c1c7f63151996ef3bdd1646282bb98c10" => :high_sierra
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
