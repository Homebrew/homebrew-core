class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  revision 3

  stable do
    url "https://github.com/libgd/libgd/releases/download/gd-2.1.1/libgd-2.1.1.tar.xz"
    sha256 "9ada1ed45594abc998ebc942cef12b032fbad672e73efc22bc9ff54f5df2b285"

    # Fix for CVE-2016-3074.
    # https://www.debian.org/security/2016/dsa-3556
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libg/libgd2/libgd2_2.1.1-4.1.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libg/libgd2/libgd2_2.1.1-4.1.debian.tar.xz"
      sha256 "ce2051fcdb161e4f780650ca76c3144941eb62e9d186e1f8cd36b6efd6fedea0"
      apply "patches/gd2-handle-corrupt-images-better-CVE-2016-3074.patch"
    end
  end

  bottle do
    cellar :any
    sha256 "07dcaf06b6f4b55fa209f1ad8a03ef549abfc789b820c7fc77762037337557df" => :el_capitan
    sha256 "acb0d79ec9ae9cbe1c114d0a772821036926dc8b2d5d09a9945037a49db21719" => :yosemite
    sha256 "7f96680ac98c529395492865f7a7ffe056e130a99c1006978682620dfa0da365" => :mavericks
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "fontconfig" => :recommended
  depends_on "freetype" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "libvpx" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    if build.with? "libpng"
      args << "--with-png=#{Formula["libpng"].opt_prefix}"
    else
      args << "--without-png"
    end

    if build.with? "fontconfig"
      args << "--with-fontconfig=#{Formula["fontconfig"].opt_prefix}"
    else
      args << "--without-fontconfig"
    end

    if build.with? "freetype"
      args << "--with-freetype=#{Formula["freetype"].opt_prefix}"
    else
      args << "--without-freetype"
    end

    if build.with? "jpeg"
      args << "--with-jpeg=#{Formula["jpeg"].opt_prefix}"
    else
      args << "--without-jpeg"
    end

    if build.with? "libtiff"
      args << "--with-tiff=#{Formula["libtiff"].opt_prefix}"
    else
      args << "--without-tiff"
    end

    if build.with? "libvpx"
      args << "--with-vpx=#{Formula["libvpx"].opt_prefix}"
    else
      args << "--without-vpx"
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
