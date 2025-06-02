class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.65.0/nghttp2-1.65.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.65.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.65.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "8ca4f2a77ba7aac20aca3e3517a2c96cfcf7c6b064ab7d4a0809e7e4e9eb9914"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "492e4dadaeb76e53e56b15180eb4ab33d8e726d5766f258f94d3628382e7a8e2"
    sha256 cellar: :any,                 arm64_sonoma:  "fa2ef36dadacb754e7233697f80a8929010e249b35dff577c86d1cf88f0ece49"
    sha256 cellar: :any,                 arm64_ventura: "8ae17c6bc3f4231f6239597d64c6cc17e9c552f9fd04c0c99cdae6c5caf8f273"
    sha256 cellar: :any,                 sonoma:        "523994aa28f56be6c23161889273d48ce9a964acfe3517768c41cf46359e27e8"
    sha256 cellar: :any,                 ventura:       "3a82bc9d1b8d32592ac19ed10d06d85405a8bfc1b180005acb757f46712f2081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca8b0e4aafcb18a1c12fa4457c849856f556e76507840ec95ded08f86f3b5e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee76cd74e324adca6f90d555ae9417164b66290a83ade8d10c272967fa85853"
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
