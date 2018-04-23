class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.4.tar.gz"
  sha256 "b62dff42202f9302ed1dfbad039134c45ff92c809052598aa1c469aab91a65d3"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "sh", "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cglm/cglm.h>
      int main()
      {
        vec3 x = {1.0f, 0.0f, 0.0f},
             y = {0.0f, 1.0f, 0.0f};
        vec3 r;

        glm_cross(x, y, r);
        glm_vec3_print(r, stderr);

        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
