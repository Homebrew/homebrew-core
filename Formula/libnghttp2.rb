class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.50.0/nghttp2-1.50.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.50.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.50.0.tar.gz"
  sha256 "d162468980dba58e54e31aa2cbaf96fd2f0890e6dd141af100f6bd1b30aa73c6"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ff36afd0e635b9be212ab7e886342ebe4faa15f4eb1fe39ffb85e68cee45fbb5"
    sha256 cellar: :any,                 arm64_big_sur:  "a828fc6fd26731035429f3feebc44659b8d75da28180103daf8a6c1ad9caac80"
    sha256 cellar: :any,                 monterey:       "76848a36505c3090d7aae71c4eaf2fb5fd66b72078b6338235c4975b2cf9de6d"
    sha256 cellar: :any,                 big_sur:        "83d2f660a954847f7f2f5ef842ee7bb6ae6697049d001f533075ce048f4b3c44"
    sha256 cellar: :any,                 catalina:       "b33c82c4e950c4217a52a450a55b3e2ec5a2716663e67c34ca1a236fc7f8be26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2467874e72ad4b90427b610d8bfa57b3fef810b9a884da5cf4582b4730c43c60"
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
    (testpath/"test.c").write <<~'EOS'
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
