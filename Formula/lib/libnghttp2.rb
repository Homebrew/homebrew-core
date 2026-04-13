class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.68.1/nghttp2-1.68.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.68.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.68.1.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "ceb434c1f9dfe2a9d305b6b797786fb9227484dfa88508d14ca1c50263db55d3"
  license "MIT"
  compatibility_version 1

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d99a0a7ca36242a71baa6bd4b172740c12c587cccbe6e211791ba4785ddec7ba"
    sha256 cellar: :any,                 arm64_sequoia: "7cd5cfb2963333e31a2f6289ee28d910cab2bc3500d449593e14f832386fb9e0"
    sha256 cellar: :any,                 arm64_sonoma:  "3d1ab9cf5210866338f17d9f451d37164e024a2fafebd774655c0df7516c5729"
    sha256 cellar: :any,                 sonoma:        "d97cfd53c7c05b1a0f48a11fa10a71c42ab1e15f7fe939cb1e9b6cbd8d07fda9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "558142ddb5ea85c7ef274fd458c4aa361ef805b8341e973f32c5a22cb751a921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53ef31dcf2bc1fdf61605957fa2235214276f4affe03591f8cefc0347fdceb77"
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
