class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.9/imlib2-1.4.9.tar.bz2"
  sha256 "7d2864972801823ce44ca8d5584a67a88f0e54e2bf47fa8cf4a514317b4f0021"

  bottle do
    sha256 "8a30dde8a2a7dbe5ed86007927ec16e940fb45fca8aab1f0317d236c08c1b577" => :sierra
    sha256 "cb81653f464c76523b160cb8ed8bc29bffec49e77605f96ff83cd7ea80efbdd7" => :el_capitan
    sha256 "1dab9c3cd20b6ba45898738e0fd00f5840bdd8b8158d6e73190ce4c949df68d8" => :yosemite
    sha256 "203d17ecfed7a366efe67e3c246c8e88cddaedc41b4fa8981b861dd6064fd3ac" => :mavericks
  end

  deprecated_option "without-x" => "without-x11"

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "giflib" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "libid3tag" => :optional
  depends_on :x11 => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
