class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.21.tar.bz2"
  sha256 "520481c9908d999f8f7546103b78ff9b11f41d25b0938f0a22f10aaa48beef2b"

  bottle do
    sha256 "74ba2202a37c82fa6a28e5b4074a892c084a00fce276b8219e666e87d36e1418" => :high_sierra
    sha256 "c6d50e75ec4d339d97c38a533704ef8a34a767a412e98dac9e081cfe2b017937" => :sierra
    sha256 "9c764b3024517ac05de3c21ee13cc12b44fc2940262611c58948cd7f398dca54" => :el_capitan
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
