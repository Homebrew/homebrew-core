class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-2.22.tar.bz2"
  sha256 "b257267cf58bf2eef31bd955d49437e165f0f1bf4e60b9ddfb460496d6670c7b"

  bottle do
    sha256 "30d7116615e59b092cd87cb244016b82cb320b9371f4a751dcb391915eac9e00" => :high_sierra
    sha256 "4a5802a6e9e8fa9a123bf52c099b1ccd8a67a79352eaa82f024489f10b24f6a2" => :sierra
    sha256 "de276ef3bec451eed266a1cb7ad576a45a46d147f79e1aab93912860d4404c95" => :el_capitan
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
