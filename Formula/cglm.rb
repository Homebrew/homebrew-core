class Cglm < Formula
  desc "📽 Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.3.tar.gz"
  sha256 "d5f58f4a4f877a5f865a6345e87b5b69807957f37f5b537039cf19988fc06f93"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "sh", "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
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
