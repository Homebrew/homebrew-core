class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.2.5/libgd-2.2.5.tar.xz"
  sha256 "8c302ccbf467faec732f0741a859eef4ecae22fea2d2ab87467be940842bde51"

  bottle do
    cellar :any
    sha256 "fa628cf6665893333ed803f194b8c1ec52d2f9883dd8cda0a354b7f56dc4c99d" => :catalina
    sha256 "4bb347ae5e66d8ba08927da7b82aad48fb6a00e278b63478894a4bde90f4c5b4" => :mojave
    sha256 "ff7aa2d452c6c05f8d41dee63bbd102fd73dbfbced7184bf0c73426adc811963" => :high_sierra
    sha256 "7a2e1ebc9ef51896aa895a94c9e5cf3d9d8be760f413930079b773de78f173d2" => :sierra
    sha256 "cece10e06be48ec2c4d1c8e995cac8ed1678b287eb982204daec2682107a740e" => :el_capitan
    sha256 "c601d7917bce645fd0c75808d45e6d61b31453ea78bdbf81f3e0b6372b93c88c" => :yosemite
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--without-x",
                          "--without-xpm"
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
