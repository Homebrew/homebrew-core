class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.26.1.tar.bz2"
  sha256 "6dc6577eb922308c1b15293c131ea31182115b288888d46d81eee89fe7a7ac94"

  bottle do
    sha256 "e10a176ec01290e0917f67742ab817f355cc61af532959d29927cabc3916eabc" => :high_sierra
    sha256 "eecb7e0c3f238319f8b080b941ed18ba9a88637fdce6ad5cb2934c7e8ecb3bd3" => :sierra
    sha256 "c1a54a718b44344eebc985adb7c4793912813810ff9102a2f9d308cff02f462b" => :el_capitan
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "libexif" => :recommended

  def install
    args = ["verscmp=0"]
    args << "exif=1" if build.with? "libexif"
    system "make", "PREFIX=#{prefix}", *args
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
