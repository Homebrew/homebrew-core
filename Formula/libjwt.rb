class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v1.15.2/libjwt-1.15.2.tar.gz"
  sha256 "787c9fa6ad0b542980b78517173e06c68d04c7e1d2f7ae91caf125951cb242e2"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "671566bd4853fccc55bce01897f5ba50b96e99af507595650735997235eee6cf"
    sha256 cellar: :any,                 arm64_monterey: "3cdd891f9b77b16dfe5fe3e33d21bb6cef6871a7d4e61d38212af30748bdf71a"
    sha256 cellar: :any,                 arm64_big_sur:  "78c42d88ed939f07f1a0dcec5d02700bf3216549fd580dcebfdc9715ff6bf538"
    sha256 cellar: :any,                 ventura:        "b21ccbe1d31add80d9c1284d246f3bf7dacbfded9c7d64ffb37a58a257090372"
    sha256 cellar: :any,                 monterey:       "9ec0adfcbf694aa8f51d5c82b4bcd47e1a1bdf814e56c4caa8c4418d08182aee"
    sha256 cellar: :any,                 big_sur:        "c017f3f8d42d2f97e2c8503e036b312e89e14f1858c4d9a63fcac198ad3db557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264745cd986ae67a0a6cf48c4da86e0906ec410afdd8c3b58602f9931fa22193"
  end

  head do
    url "https://github.com/benmcollins/libjwt.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
