class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "http://research.wand.net.nz/software/libprotoident.php"
  url "http://research.wand.net.nz/software/libprotoident/libprotoident-2.0.10.tar.gz"
  sha256 "a5ef504967c34fa07ed967b3a629a9df2768eb9da799858ceecd8026ca1efceb"

  bottle do
    cellar :any
    sha256 "0e8341bccc9208a52db3037063367190c43fb626e98915e3bec9130c69697806" => :sierra
    sha256 "df7d25c77ac8d178cd46163a1812bbbc69a7b1ca4eac37c399d5b39b584176a5" => :el_capitan
    sha256 "dc01273bfa37c0ca9cd05d2510fe597cea4e90ab038792bb6e2f51885a79e15c" => :yosemite
    sha256 "e314edb9521e0493b3d870fa27f3e2cf1e387a88a23ae48ddea45affc7181ef3" => :mavericks
  end

  depends_on "libtrace"
  depends_on "libflowmanager"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
