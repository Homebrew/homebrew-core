class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.26.2.tar.bz2"
  sha256 "6352fff798a29a731006be08e1321468202d03547434b1b0b958cb504b2b161e"

  bottle do
    sha256 "6bad39df4b0fb79348bbd50a1849efced3a2d49126c76378aa66f4a704d43832" => :high_sierra
    sha256 "7356d43d1b763bf91898538a7ae1f13ab8d27fbf2d70ad27dda0133263105a0e" => :sierra
    sha256 "530cb63876b60684fa7f2fb2a77ec13708cb3d1adfa90743765460b7821612ec" => :el_capitan
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
