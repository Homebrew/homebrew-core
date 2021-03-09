class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.8.0.tar.gz"
  sha256 "457e8baef6be048d88cdb373642af9e802e951a49f9f6cb09e8bfa005893acb6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "604f60a1ae63f364201fd851b613b7cc38ae34a4a08bfbacd22f209635e5be5a"
    sha256 cellar: :any, big_sur:       "5b427daca93de19752cc90b81b2e412aa162fac6e9d847bb9c259fb549833d1a"
    sha256 cellar: :any, catalina:      "d1b50baf51dbc8febd26b5881d83aa47e7106190adfccf6fb6339a8124b93496"
    sha256 cellar: :any, mojave:        "d7ae7bd965545a2818742d4ea1452eb3c9204c1665cc2951114ac319eda96c65"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cglm/cglm.h>
      #include <assert.h>

      int main() {
        vec3 x = {1.0f, 0.0f, 0.0f},
             y = {0.0f, 1.0f, 0.0f},
             z = {0.0f, 0.0f, 1.0f};
        vec3 r;

        glm_cross(x, y, r);
        assert(glm_vec3_eqv_eps(r, z));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
