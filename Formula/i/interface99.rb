class Interface99 < Formula
  desc "Full-featured interfaces for C99"
  homepage "https://github.com/Hirrolot/interface99"
  url "https://github.com/Hirrolot/interface99/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "8bd007c48cf05436ced60884e8e3a05ede46105f3efae9bf29e0f4d30f938f9e"
  license "MIT"
  head "https://github.com/Hirrolot/interface99.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdcd1817a2f31b433c04ed591b2f5de07141a3e783de280b0c7431b68dec2556"
  end

  depends_on "metalang99"

  def install
    include.install "interface99.h"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["metalang99"].opt_include}", "-o", "test"
    assert_equal "24 60 120 300", shell_output("./test")
  end
end
