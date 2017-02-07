class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.18.1.tar.bz2"
  sha256 "4c3840285eaf7ad474547d12870430d0392efdce4cf897666aa1ab02612e65b2"

  bottle do
    sha256 "5f3fef786e5fcd5f4425ae63dc4dcb1091a98388d38755702f9d2a354a8afff5" => :sierra
    sha256 "507e05ec459723730987908f2f4bd89c2f6fd5a63bf3d5ae7f09314c58edebfc" => :el_capitan
    sha256 "51c5e457dda2a02afc900ef46c6cb8d1d2cf88e2ff5b471dd584de3d4e3630d1" => :yosemite
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "libexif" => :recommended

  def install
    args = []
    args << "exif=1" if build.with? "libexif"
    system "make", "PREFIX=#{prefix}", *args
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
