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
    sha256 "a76839cab867bc3f0345b629e642dfbf542edf28e111d5225fd9d3e1281696c6" => :catalina
    sha256 "868ca9a9b4c3f99fbc97c45caab08ccef2d779fbdfb2a19c6b61ab0ddd42d198" => :mojave
    sha256 "bb877a698c14051f85c5e0af915ac485b58e4e1498a2a232a990eb3dffead742" => :high_sierra
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
