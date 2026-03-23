class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-1.0.1.tgz"
  sha256 "bc1cc29bca48eace5df4ba0f1aa1dfc2fe7ac773f750d4af84d80c52cece3c45"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "191a0d3f1d112f9585774eddd41909e942affd5338e7c8144d38803e986acc66"
    sha256 cellar: :any, arm64_sequoia: "709e821d80864c2780293caa51f078fdb3f900bff44e515fcf938564819e4d4f"
    sha256 cellar: :any, arm64_sonoma:  "06fef37ce17eea27851fdc51b89191eb3363c849f6f8f47b65797a22fd1aba3f"
    sha256 cellar: :any, sonoma:        "47d68ef9bc518eae514f46b1dcb7a1b25b5445fec3b67ba9eb00e58af2a62067"
    sha256               arm64_linux:   "d2864c56de92d3996fe29fc5f3bd28e8cae3fc36e3823aee230b57b53c57952d"
    sha256               x86_64_linux:  "884dac750cf8338c422c6fcd249002d42e77d2c9b6e332fea44ab048fff7c421"
  end

  depends_on "bmake" => :build

  on_linux do
    depends_on "libseccomp"
    depends_on "zlib-ng-compat"
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
    (testpath/"test.c").write <<~C
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
    C
    flags = %W[
      -L#{lib}
      -lkcgi
      -lz
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
