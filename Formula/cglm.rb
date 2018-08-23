class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.4.8.tar.gz"
  sha256 "1372dbfccca3df1cb6f9996ef9a5de898a8796160a50700f235ba98dda405327"

  bottle do
    cellar :any
    sha256 "eb3cc18d86414479c3d23acc79648b9d7ef2282005d85d6d8b8b805c74d15a2b" => :mojave
    sha256 "10e06c19e9582cfd6e5c2508278c609709a26d807cc2970be6c3c9450cd932c4" => :high_sierra
    sha256 "b250b903e4bce29ecb2df3a34502b235ee93bb1b16cc1581866fae6434310958" => :sierra
    sha256 "95403a62a99918a57d7fcb8312430cb50935eac086ad339047c0b4c825247ec6" => :el_capitan
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
        assert(glm_vec_eqv_eps(r, z));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
