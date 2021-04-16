class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.12.4.tgz"
  sha256 "e9950cda9a118a778b79bcde5a5d585a78dec4cb259731e6d9e866bcae8f3346"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf19665f8b909fc185747aeda39a2eccb74cbd5159cd8b16a4d170055001ffce"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffce6f2eb26e7855808b3528077921b371cbded63bc54ba4f640d90ff766d888"
    sha256 cellar: :any_skip_relocation, catalina:      "b215aed52ae23d42a8cb74d75195443cfff9666503863403f910b5be9fe844e3"
    sha256 cellar: :any_skip_relocation, mojave:        "ba732464c3b7a7e1c511ee93b4b03460df9979a72846511962385cc642af36fb"
  end

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
