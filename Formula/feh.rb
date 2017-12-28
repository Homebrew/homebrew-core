class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.23.tar.bz2"
  sha256 "16df3cb813526a549e854aa82f80bcb299b9e83dd687ab4216a84e86f61722a1"

  bottle do
    sha256 "2724b450fb64d70e89994db8db347deb169fb4494101420d5f7395fba6294ca1" => :high_sierra
    sha256 "e49033e406b340e34b977a9ffcc207cd96b1bbbb2170febc393c1594cc4fed9a" => :sierra
    sha256 "bf1316ca32305ce853a2aa85a7c80e44d0805fac61437b76ce7330eed6292ebe" => :el_capitan
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
