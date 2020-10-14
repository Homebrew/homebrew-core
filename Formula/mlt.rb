class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  license "LGPL-2.1-only"
  revision 3
  head "https://github.com/mltframework/mlt.git"

  stable do
    url "https://github.com/mltframework/mlt/archive/v6.22.1.tar.gz"
    sha256 "a3debdf0b8811f0d20c902cc3df3d05dad7d3ff36d1db16c0a7338d0d5989998"

    # fix compilaton with opencv4
    patch do
      url "https://github.com/mltframework/mlt/commit/08ed33a9551a0e4c0685e13da3b98bf37e08ecad.diff?full_index=1"
      sha256 "837adafbf67bc5c916f76512c989bcbc2ff1646bf7d1311d614e8e5728ad76c7"
    end
  end

  bottle do
    sha256 "70de9965c66d6fcbf24571fec70c9c8c56c6155728a59a3910b5cd059bf5f4eb" => :catalina
    sha256 "a7cca4be99a696289481ed7b7c93cd811de6c5d811c34f29aa4da8e43dadbdb2" => :mojave
    sha256 "d0d0c2df5685eaeb62bff9969fa349bcf80c62d5f338b5efa10cd019a02af1e6" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sox"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec",
            "--disable-sdl",
            "--enable-motion_est",
            "--enable-gpl",
            "--enable-gpl3",
            "--enable-opencv"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
