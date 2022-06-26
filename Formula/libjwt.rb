class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.13.1.tar.gz"
  sha256 "4df55ac89c6692adaf3badb43daf3241fd876612c9ab627e250dfc4bb59993d9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "78f15386643187ac5392bdcb5550959fcc10f52cdd3c91643b89fc48d19aaa1d"
    sha256 cellar: :any,                 arm64_big_sur:  "4d89729e216bebd3dcd95d7edca9050b125387a122e1525f2b647175074154aa"
    sha256 cellar: :any,                 monterey:       "90fed8ae1701559d47625967a0a58b276b48ae289944316f3ed006e12c5c8805"
    sha256 cellar: :any,                 big_sur:        "6007f616df31c2f700524c3dab66d9f09f5b9bcca728ac7e1b848000aabece90"
    sha256 cellar: :any,                 catalina:       "fb6e811d2e09405a322bccac174af800742fc0655a8e72a1220311eacec1b78a"
    sha256 cellar: :any,                 mojave:         "97801be0001a6c9a180d425ffecc9cef4d51a2bd246c71ec4d60c7a0016ce490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a0fc4895581847c58742ebe3d19b818f7a563265d83fec569e95f2a4f25436c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
