class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.12.2.tgz"
  sha256 "59e9219ae439f0c4fbffe6584014715c2fc206b8cd00de7aa8d062ddb52c2a0e"
  license "ISC"

  depends_on "bmake" => :build

  def install
    system "./configure", "MANDIR=#{man}",
                          "PREFIX=#{prefix}"
    system "bmake"
    system "bmake", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/types.h>
      #include <stdarg.h>
      #include <stddef.h>
      #include <stdint.h>
      #include <kcgi.h>

      int
      main(void)
      {
        struct kreq r;
        const char *pages = "";

        khttp_parse(&r, NULL, 0, &pages, 1, 0);
        return 0;
      }
    EOS
    flags = %W[
      -L#{lib}
      -lkcgi
      -lz
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
