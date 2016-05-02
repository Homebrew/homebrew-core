class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.9/imlib2-1.4.9.tar.bz2"
  sha256 "7d2864972801823ce44ca8d5584a67a88f0e54e2bf47fa8cf4a514317b4f0021"

  bottle do
    revision 1
    sha256 "bc2f73214d81c88fe174132f70347b3c2a971fef8f26cbca91e17e4765cd9c80" => :el_capitan
    sha256 "44eb001751aeffc39b81a51b672fbada43f0c0b711c238882fa145e4a0daaa45" => :yosemite
    sha256 "9f74024ffd21ca15fadef0213b9f79149a32125984dee6aa712605cb6e5a21df" => :mavericks
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
