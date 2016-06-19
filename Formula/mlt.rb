class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/archive/v6.2.0.tar.gz"
  sha256 "dd2ee742e89620de78a259790f92a7cadad67f0e0a6c1ea7ed932f96fb739fff"

  bottle do
    sha256 "b12a98b91f51fa92d9b170556a1e622bba20a65734ba12eaefb79ed52a0357bd" => :el_capitan
    sha256 "c144f768f4f12f2b54771f6f108ade717a8aefd1af1ff03659a07a2e4f39f868" => :yosemite
    sha256 "31d9b9d88ee5e76c8635c00af0951e06430d9ee20d721f420b0f539ecfbf4eac" => :mavericks
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
    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec",
            "--disable-gtk",
            "--enable-gpl"]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
