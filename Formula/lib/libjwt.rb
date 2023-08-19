class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v1.16.0/libjwt-1.16.0.tar.bz2"
  sha256 "ea9d0bff35b8b8f8f4df9d9920123f366ea4e6bb1c90ebe16143d840f146f2ed"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5737b68c54b8487d34bbc9a465338f7e605bd65a1f26f1a836999378b3689dc0"
    sha256 cellar: :any,                 arm64_monterey: "98cc184a63e3f1409805d1ab10a7a89436a73fbf92650f81798723a9e5d8941f"
    sha256 cellar: :any,                 arm64_big_sur:  "5a0d0e6714354f1837fee3ebd6b42c1bf6ac0b177c0272585e15bdcca714d8df"
    sha256 cellar: :any,                 ventura:        "128d4107b1b66d010fbcacbab88547bb9834ce2ac82e416d4f7e0a2137540b37"
    sha256 cellar: :any,                 monterey:       "b92b870b2f5f991240472b123c05dbec589eebfe562b246876fba2efb14ceb76"
    sha256 cellar: :any,                 big_sur:        "2fde3558321bf1c5bebfb24c192bdc7c72f3f3b4e256239eb6b94c38b38097e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cbe60a9957194f57afc2cf23a44a5442623819f2e704034147b8060034c097"
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
