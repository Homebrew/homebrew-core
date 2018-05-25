class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.26.3.tar.bz2"
  sha256 "3ff3e64db0811e2ff14add77d1aab4ae6d16616f5f78fe54649b49f5aa7f4a21"

  bottle do
    sha256 "5437b331014daf075535ec5b3c59c350c3b91bb00a89e132360ef3e062213b3e" => :high_sierra
    sha256 "f7f601e8cabce54efa69b98f40f3f0f4cce35d2736728a2b211edb55b7a5b0a7" => :sierra
    sha256 "bce2f11ed546d827d04c7d449db6cedb631d9ae67e81d55187722e0a784591b4" => :el_capitan
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
