class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "http://research.wand.net.nz/software/libprotoident.php"
  url "http://research.wand.net.nz/software/libprotoident/libprotoident-2.0.10.tar.gz"
  sha256 "a5ef504967c34fa07ed967b3a629a9df2768eb9da799858ceecd8026ca1efceb"
  revision 1

  bottle do
    cellar :any
    sha256 "f79fbc4434ba1a5fbb97eb3dbcb29374d9d181a4b56eb6a00eb764f9ded0ceab" => :sierra
    sha256 "63001eb37e9e7a65014e5244c70e74a4f7403678dba12f1444a28066d70f5518" => :el_capitan
    sha256 "93489944b1b8c79c196e420524b45a0cec95e27c540683d6d1c040c19874b368" => :yosemite
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
