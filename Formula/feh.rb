class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.23.2.tar.bz2"
  sha256 "96c131a558fd86d9a83862abfabbfc7c081b8a4d5c9d56598e04905a21ec89c3"

  bottle do
    sha256 "009b74407942e3eb062b2c282d68624bd4554f7621981708724aa59f98281b76" => :high_sierra
    sha256 "a4a1382dc4ed4666dcd929833ade0fdb292b73b54eb6cb3b673d0e25e2b88cbc" => :sierra
    sha256 "49e99437dfaad55c834a74067344ea07a264c8c97ce0d60abe8226c79ca67dae" => :el_capitan
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
