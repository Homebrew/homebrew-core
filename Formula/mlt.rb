class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  license "LGPL-2.1"
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
    sha256 "ba79a7fdec91b58e1d53ab88b6d970215b11c33d758a931fa24a9035ff9a3e5f" => :catalina
    sha256 "a8f1cd443ea52e7640f19d0b814ab22eeae837690463f44f449add99357cdbeb" => :mojave
    sha256 "e33d6c696dc158d47e53ee9eb92d4171c0e2c034ffac41fff33f3ef111a993a4" => :high_sierra
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
