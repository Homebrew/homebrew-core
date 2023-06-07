class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.53.0/nghttp2-1.53.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.53.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.53.0.tar.gz"
  sha256 "f5f3f18b377d1e7658e4655a32d9a7ce6fef39fa13f600fe920f5f77c60fc34b"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e659bf1d766988ddd50684dfd9df144d5701b5b42b02b8b34ed8873add8b891c"
    sha256 cellar: :any,                 arm64_monterey: "ce807466c0310e903e9c70d2f84cf0f73e82c04934132f79ff13cf868d524305"
    sha256 cellar: :any,                 arm64_big_sur:  "b807ca1f215940ba8a79e9ddac242ce035259257aa10c72e6be0c815206c25aa"
    sha256 cellar: :any,                 ventura:        "9912b1b182a85ccd179dc41e6083ff67b607cd11b0f37de5c811223fe780a8d3"
    sha256 cellar: :any,                 monterey:       "143deac9159a3c6ed407a27d0fd07e1f84a8671a48a9f6a3a237253074599156"
    sha256 cellar: :any,                 big_sur:        "3faee6450d6445d7fed1413ac1b8039e94fce368ff8b3e0c03b3f35ff92cef25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd5ce47a47ca1b9fcb4181d59da2ddcbddb3af351e4397d187b7de5a21b7afe"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  # These used to live in `nghttp2`.
  link_overwrite "include/nghttp2"
  link_overwrite "lib/libnghttp2.a"
  link_overwrite "lib/libnghttp2.dylib"
  link_overwrite "lib/libnghttp2.14.dylib"
  link_overwrite "lib/libnghttp2.so"
  link_overwrite "lib/libnghttp2.so.14"
  link_overwrite "lib/pkgconfig/libnghttp2.pc"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", *std_configure_args, "--enable-lib-only"
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nghttp2/nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
