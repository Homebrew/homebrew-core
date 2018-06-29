class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.27.tar.bz2"
  sha256 "af326845ef7483ecbffde697fdadb39298a68069d79644e249c69c9ad464c64e"

  bottle do
    sha256 "31663d3cf333f653f0deed2396af70789e8c1b12b6825c1785187a503d35d268" => :high_sierra
    sha256 "12ddcd65cc0da11e87565022f9116c38b0a1ae2587dc9c11256faf348c1edcb9" => :sierra
    sha256 "24f08721d2a7f93e09a55c2cb7cbc3e94eca587ac658cf18b67655a6618e0574" => :el_capitan
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
