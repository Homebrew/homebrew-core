class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/archive/v1.14.0.tar.gz"
  sha256 "df7e753b3a523008d7994396afec0ad4f02e5d5636da54319b07ad2c4eb38cd0"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "38ed9509a429014b28882a5970ef64e157a1906514c5f7a593c05af43d0948e0"
    sha256 cellar: :any,                 arm64_monterey: "fc108cdd5c78b51c76ff7abcbcfb20db01521b4e2f665ce1f73079045ff2dd97"
    sha256 cellar: :any,                 arm64_big_sur:  "3749847000103f76c8c72f33edcd3e00855c90fb5e99cb8080362be362cd4cae"
    sha256 cellar: :any,                 ventura:        "d7a7fb357819054f228e7ee33508861639893c461408d9e2aea6c0ad0a7c01c8"
    sha256 cellar: :any,                 monterey:       "f98f21791845f8ad5154e826a8bdfb586d7ee509ad150b8a94f77a97ddae39d6"
    sha256 cellar: :any,                 big_sur:        "f8a4776cb98a8e345b7ab2e9d3753703e91a56c264d0e4568413a548e3bd2f23"
    sha256 cellar: :any,                 catalina:       "c89546a6d4f6fcac752fa3a1a1d1ee91d88af04c062fb4f619c4414f9e8e1048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba773969e167750e3cfa3b297bfb7c1a0713eac508c6181dbbd09dd77031b745"
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
