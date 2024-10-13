class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.13.4.tgz"
  sha256 "cc5f75ea75e42ed4f67e9ef831c0387717cedbc65c2261a828bee7956e46a259"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ede6da1f7d9ea340cc19bf6a539948dd87a0aa20bb179e4c669a7fa94a6bd99"
    sha256 cellar: :any,                 arm64_sonoma:  "9da91cadc2de7c8b9736dd73a28f2e9f39f5d7fb25acae212efdb5d6e52a25ef"
    sha256 cellar: :any,                 arm64_ventura: "0314195b4c86b877610fd9035b7906122316bddd3cfaa2982395797a4bb75912"
    sha256 cellar: :any,                 sonoma:        "4bd93297c59a4102abb6ddb1ef0e1d53de162e7c71aeb53e8da29824d3a1dbbe"
    sha256 cellar: :any,                 ventura:       "ea274424cd3b9f8b69bb7e7a78c89aeda17728716a4b4576b73bdfb8253f5ad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1d317a28397ff207c48149f3b9d4241bbf44b88f6f712091dfcb5b1f6963a2"
  end

  depends_on "bmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "./configure", "MANDIR=#{man}",
                          "PREFIX=#{prefix}"
    # Uncomment CPPFLAGS to enable libseccomp support on Linux, as instructed to in Makefile.
    inreplace "Makefile", "#CPPFLAGS", "CPPFLAGS" unless OS.mac?
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
