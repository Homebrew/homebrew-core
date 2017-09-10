class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.20.tar.bz2"
  sha256 "4b504302099ec6dd099c84dd7e285c80dc318977ebda48949593386bc26e700b"

  bottle do
    sha256 "9c66f5df7b0a580a683801ade00000e85db228dc99485a297e7e3a916149bd99" => :sierra
    sha256 "4d297510bb5e87da7e25273bb27d757cc61394ef1725a7ea4230e6dfbdcffff6" => :el_capitan
    sha256 "37155adae534dd8d2ed5a267d2b90cbb1dd41e9481b7e0c864938a6cffa3b99f" => :yosemite
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
