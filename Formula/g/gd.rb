class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
  sha256 "3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61"
  license "GD"
  revision 6

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "db4a448757d199dc1a925c0d0b36a990c8126ab81cf6a634374cd7307d042fb0"
    sha256 cellar: :any,                 arm64_sequoia:  "c4e22a92d28f3b8a49c10e29cf04f5a9b4b4932691ec4326021bc149ac0dae4c"
    sha256 cellar: :any,                 arm64_sonoma:   "e278f6f79e6ac00c5f0f14bc8980197c89426eab2ba90d8fc1e82da777fb8378"
    sha256 cellar: :any,                 arm64_ventura:  "3f868f36cc47f91ea2a896c4b6ea62fab9b3ef94d7765f34234b277ee46788af"
    sha256 cellar: :any,                 arm64_monterey: "98906db0b5efdd3a46296035df0ec9a99ebfbf5d6c6d76d7af5e2862152a6c97"
    sha256 cellar: :any,                 arm64_big_sur:  "1751a4ef467688acf597319f376dc0e69074c96d613ba22c381157dfeec85073"
    sha256 cellar: :any,                 sonoma:         "7bc1099e53432209a4c5da106c8105e0f8e95728a6cc77438e2761c8b6fcf05b"
    sha256 cellar: :any,                 ventura:        "4a75b4a92fbe6e26a47104496b6bfbaeffa73ac76d4290e68e81603de5b0f41f"
    sha256 cellar: :any,                 monterey:       "4921f275ca5a840aaa215939f80dbb4adef8a13b2bcd43608428518d4730cad4"
    sha256 cellar: :any,                 big_sur:        "f398c94388423665c26840a86d073ba43da0b519ea3b114c58d14e50edbdd47d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dd5992ca69dd7f7e38228b403e1e4297b56eee6850a7b59a592da2130d158ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da124ea2c614748107f9683ed08afa140d98a5d429332137f4f6ce17460360ec"
  end

  head do
    url "https://github.com/libgd/libgd.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"

  conflicts_with "mummer", because: "both install `annotate` binaries"

  # revert breaking changes in 2.3.3, remove in next release
  patch do
    url "https://github.com/libgd/libgd/commit/f4bc1f5c26925548662946ed7cfa473c190a104a.patch?full_index=1"
    sha256 "1015f6e125f139a1e922ac4bc2a18abbc498b0142193fa692846bf0f344a3691"
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--with-fontconfig=#{Formula["fontconfig"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-jpeg=#{Formula["jpeg-turbo"].opt_prefix}",
                          "--with-avif=#{Formula["libavif"].opt_prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-tiff=#{Formula["libtiff"].opt_prefix}",
                          "--with-webp=#{Formula["webp"].opt_prefix}",
                          "--without-x",
                          "--without-xpm"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "gd.h"
      #include <stdio.h>

      int main() {
        gdImagePtr im;
        FILE *pngout;
        int black;
        int white;

        im = gdImageCreate(64, 64);
        black = gdImageColorAllocate(im, 0, 0, 0);
        white = gdImageColorAllocate(im, 255, 255, 255);
        gdImageLine(im, 0, 0, 63, 63, white);
        pngout = fopen("test.png", "wb");
        gdImagePng(im, pngout);
        fclose(pngout);
        gdImageDestroy(im);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgd", "-o", "test"
    system "./test"
    assert_path_exists "#{testpath}/test.png"
  end
end
