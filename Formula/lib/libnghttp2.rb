class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.68.0/nghttp2-1.68.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.68.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.68.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "2c16ffc588ad3f9e2613c3fad72db48ecb5ce15bc362fcc85b342e48daf51013"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52867bf3affcb7431ad4c5d10071cb184090819fe54ed7e0d000fb3df35ffda8"
    sha256 cellar: :any,                 arm64_sequoia: "65c944b77dd8e8583f9e1fd0820cd81fe2b12f5b7a1992350386dd2e1a117257"
    sha256 cellar: :any,                 arm64_sonoma:  "df1ab82f0ed698ee1ed6330f1a9269faef489a13552c43922fa27798ec7997d3"
    sha256 cellar: :any,                 sonoma:        "b848ec2c3a09ee31c4a1b6923c100dc0c1056e907f933f2d368c594a0175dd39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26ffb75ba49c68b33064eee833f985fd49004c3ef0c99640b15a93725461b60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e46e74960c990d7b866a1c931d1292fd921ff25e3508c6884d0845fb58633e1a"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  # These used to live in `nghttp2`.
  link_overwrite "include/nghttp2"
  link_overwrite "lib/libnghttp2.a"
  link_overwrite "lib/libnghttp2.dylib"
  link_overwrite "lib/libnghttp2.14.dylib"
  link_overwrite "lib/libnghttp2.so"
  link_overwrite "lib/libnghttp2.so.14"
  link_overwrite "lib/pkgconfig/libnghttp2.pc"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--enable-lib-only", *std_configure_args
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nghttp2/nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
