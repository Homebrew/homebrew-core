class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.19.tar.bz2"
  sha256 "cebe25d8393a07aa79a6b2f99beb133d8de0cbc00d46bccc4df276248cc9d0e9"

  bottle do
    sha256 "858a26743f98e82c10f2c8acf417320118f7a66dd545f71b88a09ac9a90adcf1" => :sierra
    sha256 "0dc600aee784261ae78b080042b460c8c3c3489101de2aee4eab8a130cdbae31" => :el_capitan
    sha256 "29bd7a493ef6948e58540b8990bd37a70c0327130422a8f988660fd5bffbe2e0" => :yosemite
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
