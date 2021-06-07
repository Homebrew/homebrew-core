class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi/"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.6/libmobi-0.6.tar.gz"
  sha256 "c35bd44279575bf8b102d23eba482805bfc1e5a49df8414d851507e8ea811c5d"
  license "LGPL-3.0-or-later"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
