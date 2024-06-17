class Interface99 < Formula
  desc "Full-featured interfaces for C99"
  homepage "https://github.com/Hirrolot/interface99"
  url "https://github.com/Hirrolot/interface99/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "ddc7cd979cf9c964a4313a5e6bdc87bd8df669142f29c8edb71d2f2f7822d9aa"
  license "MIT"
  head "https://github.com/Hirrolot/interface99.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "332dcbf6cb579b176aaa88edb543da80015b8f47b83c9c7b5f15c7cdeef9082d"
  end

  depends_on "metalang99"

  def install
    include.install "interface99.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <interface99.h>
      #include <stdio.h>

      #define Shape_IFACE vfunc( int, perim, const VSelf) vfunc(void, scale, VSelf, int factor)

      typedef struct { int a, b; } Rectangle;
      typedef struct { int a, b, c; } Triangle;

      int Rectangle_perim(const VSelf) {
          VSELF(const Rectangle);
          return (self->a + self->b) * 2;
      }

      void Rectangle_scale(VSelf, int factor) {
          VSELF(Rectangle);
          self->a *= factor; self->b *= factor;
      }

      int Triangle_perim(const VSelf) {
          VSELF(const Triangle);
          return self->a + self->b + self->c;
      }

      void Triangle_scale(VSelf, int factor) {
          VSELF(Triangle);
          self->a *= factor; self->b *= factor; self->c *= factor;
      }

      interface(Shape);
      impl(Shape, Rectangle);
      impl(Shape, Triangle);

      int main() {
        Shape r = DYN_LIT(Rectangle, Shape, {5, 7});
        Shape t = DYN_LIT(Triangle, Shape, {10, 20, 30});
        printf("%d %d ", VCALL(r, perim), VCALL(t, perim));
        VCALL(r, scale, 5);
        VCALL(t, scale, 5);
        printf("%d %d", VCALL(r, perim), VCALL(t, perim));
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["metalang99"].opt_include}", "-o", "test"
    assert_equal "24 60 120 300", shell_output("./test")
  end
end
