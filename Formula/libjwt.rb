class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v1.15.2/libjwt-1.15.2.tar.gz"
  sha256 "787c9fa6ad0b542980b78517173e06c68d04c7e1d2f7ae91caf125951cb242e2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01dab5d9eb1038814b828c8644ff0afb6de6c67b242efcef06dc24f40fab142a"
    sha256 cellar: :any,                 arm64_monterey: "0c0d3c07150ee851a611d7ffa3e16e5169d85d37c8d993b9aa37032ebe549261"
    sha256 cellar: :any,                 arm64_big_sur:  "c081246d6ae05f549196caf2c54f6dc9798fee400631b12bd46378cb7f04693a"
    sha256 cellar: :any,                 ventura:        "e7cd5e64035f67605a05f34cb9a3d7919a77e7003eca23683c9c8ec0cbe357a0"
    sha256 cellar: :any,                 monterey:       "c50864c217d2f9b56a61fc6a3c9a00d2276c0ec9d01449f6ed9704bbcff9cd07"
    sha256 cellar: :any,                 big_sur:        "0e019f0d4ea6a8a47035e5486a9fd3146b5e16504d52574240731c4dd84c21a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a565e93953d5507285a6af830da7136fe5fa3a7482c2b569f52efbdef0546e0e"
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
