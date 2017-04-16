class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.10/imlib2-1.4.10.tar.bz2"
  sha256 "3f698cd285cbbfc251c1d6405f249b99fafffafa5e0a5ecf0ca7ae49bbc0a272"

  bottle do
    sha256 "5dc22a4152e58bfe2904fdaaffac11969533ef53ed82f5cd73e426cecfb8a226" => :sierra
    sha256 "9ab5d77db490a64419a743ec4925f4e7ef3efe0c5d8faa93a86c3c24fe61be1d" => :el_capitan
    sha256 "90a72c95bc99270c3ae082aca367ecd74b55a60c6d6fe101a4205316ae7c0d70" => :yosemite
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
