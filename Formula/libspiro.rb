class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://github.com/fontforge/libspiro/releases/download/20221101/libspiro-dist-20221101.tar.gz"
  sha256 "5984fb5af3e4e1f927f3a74850b705a711fb86284802a5e6170b09786440e8be"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "51c8921af221ce78f184e95a55a79e81d38fc1fa84abe2dc46625a57788e6b0e"
    sha256 cellar: :any,                 arm64_monterey: "1e90fd585fcaa84a166d7a77c2ae5aeb97fd8692c98dc5b2f6952d9d9033bf9a"
    sha256 cellar: :any,                 arm64_big_sur:  "d2d54755d2a1a15ab93350e6a74697357a7e7478f9a53e78d7c40b2c47fd9651"
    sha256 cellar: :any,                 ventura:        "5721b7e65026b5a86e387c4f648925b6e9166825b158226fbfb6a4ce2387c2f4"
    sha256 cellar: :any,                 monterey:       "946ef3d6e92c177e4456421353ed3090128d8eebca4630bcd8f1ee1cd4bb9b49"
    sha256 cellar: :any,                 big_sur:        "f95068a1f9cb22591a2e37cb2b061199f8f624cbab15d743b1176438020fb119"
    sha256 cellar: :any,                 catalina:       "a4487593a91bce4bdd4456bee4f3a31219d03ed1c6960e6d998d551e50e186df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4dfa30c267a3b79aa235c9569a0289ebce4cd3d8f0a570c4fc48fea840d9ff3"
  end

  head do
    url "https://github.com/fontforge/libspiro.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <spiroentrypoints.h>
      #include <bezctx.h>

      void moveto(bezctx *bc, double x, double y, int open) {}
      void lineto(bezctx *bc, double x, double y) {}
      void quadto(bezctx *bc, double x1, double y1, double x2, double y2) {}
      void curveto(bezctx *bc, double x1, double y1, double x2, double y2, double x3, double t3) {}
      void markknot(bezctx *bc, int knot) {}

      int main() {
        int done;
        bezctx bc = {moveto, lineto, quadto, curveto, markknot};
        spiro_cp path[] = {
          {-100, 0, SPIRO_G4}, {0, 100, SPIRO_G4},
          {100, 0, SPIRO_G4}, {0, -100, SPIRO_G4}
        };

        SpiroCPsToBezier1(path, sizeof(path)/sizeof(spiro_cp), 1, &bc, &done);
        return done == 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspiro", "-o", "test"
    system "./test"
  end
end
