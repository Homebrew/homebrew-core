class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://github.com/fontforge/libspiro/releases/download/20220722/libspiro-dist-20220722.tar.gz"
  sha256 "3b8e54473f3d4d99c014f2630e62f966f5f4e25c28ca59b63d30bd8e9b7593f5"
  license "GPL-3.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3498c1a31dba2bbd728c4940c270458a946e2b0b4318a92d611d825b93c56f5"
    sha256 cellar: :any,                 arm64_big_sur:  "586a41d1ce7658531787026822d18043dce42b0f31f89f2506f544b28a156e4c"
    sha256 cellar: :any,                 monterey:       "37809c1fcd66a6e7f33a8113b04d6799f9740b6a4407a32229f0d8985a38c42b"
    sha256 cellar: :any,                 big_sur:        "c1022c3d1173013815484d27276a03a251fcc6bf44eacdc74c9baf00e0e9ad5a"
    sha256 cellar: :any,                 catalina:       "0856dba557c27a3f09a10791e7030aacfd4e8093dc169ecc68d6dd350b6ac146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd949a77a584f8a6783e9432a48f0601c1fec3600f8c0e0dc26a93c32418a1f1"
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
