class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.56.0/nghttp2-1.56.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.56.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.56.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "eb00ded354db1159dcccabc11b0aaeac893b7c9b154f8187e4598c4b8f3446b5"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a6818407f5e9ae53d8ea8dc13829d79ba9744cc353e28472e5b19bbdaff37392"
    sha256 cellar: :any,                 arm64_ventura:  "1093a53fd7a53100938b84fc252e519013397dc93ec7a831de9a37df2e8687a6"
    sha256 cellar: :any,                 arm64_monterey: "3e941cd6e05a9b14594a264c194f103914f0134f26b0f48f34b55937fde030fc"
    sha256 cellar: :any,                 arm64_big_sur:  "4b2ae238cbfc87656720a16480625a64e46e0f88f2ff4054cf561f5bae14e43b"
    sha256 cellar: :any,                 sonoma:         "d0e9278a2771ddb91b84d05a65139acb8e01bb46a3ba0a207ae42e0c38a86859"
    sha256 cellar: :any,                 ventura:        "83f4a52423c05b237b7fd00f859254181b69cab5a9c6cc8b92afc8cd3da18453"
    sha256 cellar: :any,                 monterey:       "104e08aefc3de2d8307b6220364d9cbb78dc3540057b47e4e8f34eb6c9a32f56"
    sha256 cellar: :any,                 big_sur:        "7d8ee013d8e33505d1efc34a69fe8993b542f65168bdff617330dd9eadb95818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86fda5779ba7f2376149b9c11120dff13b862dd42dc84e93b713ddc3844c4db8"
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
