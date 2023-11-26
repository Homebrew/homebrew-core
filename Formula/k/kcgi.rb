class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.13.2.tgz"
  sha256 "63015ad94418749a9ee402b91d686bb26e9ea108c4994e7b91713c95952b2175"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfd11a18fcc780e1b5633b4a6bcfbaa3ca038f3f43a43b1b3f10c97f24bd74d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee27542043bf2ad17d59e30a5031015ad6fe0ee0b904c1d0f0c77ff442524269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5e06977a915e3b64d6ba44937dadd62cb6d9dccd5be9be6818a9dd3a640db0"
    sha256 cellar: :any_skip_relocation, sonoma:         "04cb261b31b014fa155de0f61fb01430d508173ccdc915214f9ba84a2c648cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "6cc585147ac24b55ca342a69b33e3bd8fb9014f1b001456e85bdd1e2ca5d09f8"
    sha256 cellar: :any_skip_relocation, monterey:       "df3b96ab72c60f0a9d43fb985a4f895e8d2956894f77637c26e21f49a2dac9ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8d560e34bcfba9eeb6f70c41519c309a7344b88870dd4d30247834867deffc"
  end

  depends_on "bmake" => :build

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
