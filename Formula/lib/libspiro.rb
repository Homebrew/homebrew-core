class Libspiro < Formula
  desc "Library to simplify the drawing of curves"
  homepage "https://github.com/fontforge/libspiro"
  url "https://github.com/fontforge/libspiro/releases/download/20240903/libspiro-dist-20240903.tar.gz"
  sha256 "1412a21b943c6e1db834ee2d74145aad20b3f62b12152d475613b8241d9cde10"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "108c9578c13a97e6b0b0eed7c7a4ec74d43d5128300f7c68c6688e223ccd0bf7"
    sha256 cellar: :any,                 arm64_sequoia:  "ca6d88ca75e54af10d0342111a00a6bb3d2f6b5b80504a97d354c6b93ac114b9"
    sha256 cellar: :any,                 arm64_sonoma:   "e7631acf319b2660d2ae284cb33084fd3eadcd99311192ef8fea522929e7868a"
    sha256 cellar: :any,                 arm64_ventura:  "177d17bb91576650898dbdcc8de1676d83fb65131a0b5cf9b1972ab0b59d5503"
    sha256 cellar: :any,                 arm64_monterey: "ef628c12ea5473facb76eba3200e60d71a3ef1282625bb876caabe6d85448df9"
    sha256 cellar: :any,                 sonoma:         "993047020b74cfc6c22f4b7f6ccc71d177b76b0804729cdcc03af63ac5d9ffd0"
    sha256 cellar: :any,                 ventura:        "92806cce5c7b5384bdbf277025d4b2b92bf9934b0c689f480bd4af25312fbf34"
    sha256 cellar: :any,                 monterey:       "559b51f880b7392ceef800f586bdb5a0bca48dd2c1da24cde626f7a2b7d647e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b086a99529c5a1725d4b5381f1f3f8ea34167db13247dfe0612f97deeef8f4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27ecaaf681b49db47d118fe90a1fe0b9600dceb7b95f770233d8a218a67fe438"
  end

  head do
    url "https://github.com/fontforge/libspiro.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "--force", "--install", "--verbose"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspiro", "-o", "test"
    system "./test"
  end
end
