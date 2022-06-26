class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://github.com/fontforge/libspiro/releases/download/20200505/libspiro-dist-20200505.tar.gz"
  sha256 "06c69a1e8dcbcabcf009fd96fd90b1a244d0257246e376c2c4d57c4ea4af0e49"
  license "GPL-3.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "16386871ef1e3136563fa5fa1d0079f39af32c6971b9072bd3775e56f66859cf"
    sha256 cellar: :any,                 arm64_big_sur:  "4415d981f900b8187bbe5aeb94c4e6f14e2131277f0adaccef5fa2e793067918"
    sha256 cellar: :any,                 monterey:       "1c140e2c95c5519ecbfedd2dcab839fe31f3affe4dfbd0e371d94462e5229ad0"
    sha256 cellar: :any,                 big_sur:        "76ef3ec2cffe248bceafb680e741fc062d1c3b115d5b105632678d34eeb62f20"
    sha256 cellar: :any,                 catalina:       "238761be2cd640f6c3f59f0461ce7f5b73dc71c9613236e180bc55f4231e167b"
    sha256 cellar: :any,                 mojave:         "fb1b2e548eddc684a5b615cedabc2c6403e0c87409fdb419369ca40e2b70aa52"
    sha256 cellar: :any,                 high_sierra:    "b7155fe14b9909a06a9044ca2d3275f5b2cbcd9aac23583b3819ba53898ff120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75b6528d51d32b13be0f7fb68b72407f877cce2c89c774ca7c1da1dfbcbea786"
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
