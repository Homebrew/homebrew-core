class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.64.0/nghttp2-1.64.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.64.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.64.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "20e73f3cf9db3f05988996ac8b3a99ed529f4565ca91a49eb0550498e10621e8"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3851a8e7b386b11e2169671cf3b04acf811fceb406a67f94f9f2ecece9c9794"
    sha256 cellar: :any,                 arm64_sonoma:  "13eddf43c08a660b4efb246dae54ef46fedb6cb083a916fa4900a6906297fd2f"
    sha256 cellar: :any,                 arm64_ventura: "2a9ac2b92f79808902b895ec2cabd0cdb9551f99256b700e45ae6f0041a3db0f"
    sha256 cellar: :any,                 sonoma:        "d89b39d43e99f59cd325cf8a61a6aa8a295deebf29c22ab0bc3185ff4ec26a54"
    sha256 cellar: :any,                 ventura:       "8c755a5d140ed127dba02f303df785f687447cbfa6b302d4e741d819b322ff07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4c922766aa304a0f749d7f9c019cd77f9706ac65ce0223857f60c68760319f"
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
