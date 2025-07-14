class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.66.0/nghttp2-1.66.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.66.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.66.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "e178687730c207f3a659730096df192b52d3752786c068b8e5ee7aeb8edae05a"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41c3c42b773f4a02cdd9e4f7724e10aea9b6bd1ee2a78408fb02083725a1443f"
    sha256 cellar: :any,                 arm64_sonoma:  "85e76ae188d10f4d83851ef00582a643f2705f253ff51094c343a0cc027c2f58"
    sha256 cellar: :any,                 arm64_ventura: "cd939c459dadf040f5268d14496986d3884ab19b95e5bd342bd9478f6f10d701"
    sha256 cellar: :any,                 sonoma:        "ad8bf90461b2644c68a52eac9f1bee68878a646d8f66cd4440e9896b8bb9df3d"
    sha256 cellar: :any,                 ventura:       "ca3275b8e548d6a0e3a614c7cf03f32ac9142917f270ee95e19489211e5b0ec7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21619452882e67ec44b9c0a541a1928bc3f55838ae7fc83b5fd197d13100907b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ffa3bde661552df4e257400ac387aee06b9e2ef4d9ad4822c6b8ad571e2d488"
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
