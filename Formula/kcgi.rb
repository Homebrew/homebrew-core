class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.12.3.tgz"
  sha256 "96b869f50799c245dc25946b160f1dfa0c321eaaf14a1b63e28e58475edee112"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d3c70c055debc2d11e7bbd7b5df4730e22c59d5476a937c55283c4925d29799" => :big_sur
    sha256 "3fc4230160aa06daffdf7ecf1d163c7ef51f251f8a0af41895dce2758e17d8ec" => :arm64_big_sur
    sha256 "0f50618443011bede00b008698b0fa954660771e0970dd744d625ffca9295095" => :catalina
    sha256 "27eb935afbc082aee20734a400d229f96d24a54a0e703fb2dc251923852a0ea0" => :mojave
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
