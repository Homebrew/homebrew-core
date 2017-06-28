class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.19.tar.bz2"
  sha256 "cebe25d8393a07aa79a6b2f99beb133d8de0cbc00d46bccc4df276248cc9d0e9"

  bottle do
    sha256 "34b36782e60141ac1aae7d0964f50f742bdf0f8480437ea54f0278f3ff8af952" => :sierra
    sha256 "60d6c4cae83fdf4d331224252d9d31714a0d785758c209796b83810ab0c3ec0b" => :el_capitan
    sha256 "7a27da4b85b43078b81dade2a3b67347dada513e44a5f1c19e5311d53c9a9771" => :yosemite
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
