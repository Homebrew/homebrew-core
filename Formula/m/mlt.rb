class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.42.0/mlt-7.42.0.tar.gz"
  sha256 "8800e343f43aaa885bd5d9d23553030fa220aa3e2f0c94d9fd6a936d41638cdd"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "a6ea73abbd41e37949bec755e903419f980c564489184671f09adf87c95ce3d3"
    sha256 arm64_tahoe:       "0c00321c3a3386c36fc2261b06ba58feee58d19cc48ccdaab4c86ef74df2063b"
    sha256 arm64_sequoia:     "7bd54eca36d6e54488df31bef435dfd8a46b221921db3472eaee91e7d459311b"
    sha256 arm64_linux:       "f08671f700480ca084a9add436469eb1ff02905ec631ec8a213e559c720c812b"
    sha256 x86_64_linux:      "bb934f133afc4027b691ab2ff856b2c756009bb98e95dab99d0069d898fdf729"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "opencv"
  depends_on "pango"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "rubberband"
  depends_on "sdl2-compat"
  depends_on "sox"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "freetype"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libomp"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  deny_network_access!

  def install
    rpaths = [rpath, rpath(source: lib/"mlt")]

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DGPL=ON",
                    "-DGPL3=ON",
                    "-DMOD_JACKRACK=OFF",
                    "-DMOD_OPENCV=ON",
                    "-DMOD_QT5=OFF",
                    "-DMOD_QT6=ON",
                    "-DMOD_SDL1=OFF",
                    "-DMOD_MOVIT=OFF",
                    "-DMOD_RNNOISE=OFF",
                    "-DRELOCATABLE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Workaround as current `mlt` doesn't provide an unversioned mlt++.pc file.
    # Remove if mlt readds or all dependents (e.g. `synfig`) support versioned .pc
    (lib/"pkgconfig").install_symlink "mlt++-#{version.major}.pc" => "mlt++.pc"
  end

  test do
    system bin/"melt", "-profile", "atsc_720p_25", "color:red", "out=4",
           "-consumer", "avformat:output.mkv", "vcodec=ffv1", "an=1"
    output = shell_output("#{formula_opt_bin("ffmpeg")}/ffprobe -v error -select_streams v:0 " \
                          "-show_entries stream=codec_name,width,height -of csv=p=0 output.mkv")
    assert_equal "ffv1,1280,720", output.strip
  end
end
