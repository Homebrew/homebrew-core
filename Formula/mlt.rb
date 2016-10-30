class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.2.0.tar.gz"
  sha256 "dd2ee742e89620de78a259790f92a7cadad67f0e0a6c1ea7ed932f96fb739fff"

  bottle do
    sha256 "9da4f1754f388a089af07d9f003c5589684b45cdb3f55f2933a83944f1e8d292" => :sierra
    sha256 "37b56fd9ab3a237a6034c3cd5705881f0d09fe8eab0154b187f7de2f963463bf" => :el_capitan
    sha256 "ac7e712edae8c1a510e8ffae58c5388b8390242090c78f820ff7aa0cf9331fea" => :yosemite
    sha256 "492c149e06c91af7083d1a454dbf61b1f7f90129f254496db794683521ee7899" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "sox"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-jackrack",
                          "--disable-swfdec",
                          "--disable-gtk",
                          "--enable-gpl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
