class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v1.17.0/libjwt-1.17.0.tar.bz2"
  sha256 "b8b257da9b64ba9075fce3a3f670ae02dee7fc95ab7009a2e1ad60905e3f8d48"
  license "MPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d529c193f8a33bd5fa79321c8aba7fd6f474cb0353b54b54c2cdc6ed92fa543f"
    sha256 cellar: :any,                 arm64_ventura:  "66bad1a8957b19388528dbcaa5761afaa5760cff5782c2de52a2a739468e265c"
    sha256 cellar: :any,                 arm64_monterey: "9567d7b2b04866173df2a33fd6109409a44194e0500fe867068c3280da2a97cb"
    sha256 cellar: :any,                 sonoma:         "a2c3941e80d85fdd0cf2e4d324d5fcc171e1c018491c6c9c95d92f4c622d86ea"
    sha256 cellar: :any,                 ventura:        "d01f570cfd764f3c3c442275b6e6480b8362bef77053fcc31e9f654813b82979"
    sha256 cellar: :any,                 monterey:       "b07b3eb345222f0a73cb6e3c0361c4d016e40b5275e04e29c841c7a4e11e340a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c9f7e64468ff49779273c29f12751d0d292dffe78c3fd9f00c3ea4b51d7e39"
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
