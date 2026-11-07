class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v7.42.0/mlt-7.42.0.tar.gz"
  sha256 "8800e343f43aaa885bd5d9d23553030fa220aa3e2f0c94d9fd6a936d41638cdd"
  license "LGPL-2.1-only"
  revision 1
  compatibility_version 1
  head "https://github.com/mltframework/mlt.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "f8c2b582ab2106dab0be2c3e21fadf3cd59ae4690162e7bc2396816620b4cbcb"
    sha256 arm64_tahoe:       "cf8d5587e2b0bedac5b12d164dcb53eb1989b1a990095ec940e42428a91dbf3f"
    sha256 arm64_sequoia:     "e6794e1dcf2b135c681701a73d4e1acd842334f331426317ed6debb304c961b6"
    sha256 arm64_linux:       "823601198cd6a9e735e4ea1f720787ee4367391e62a9f244ef68ab2fc51e8509"
    sha256 x86_64_linux:      "88864417787456fdcd3300cd3a42a36fb93a1a541afbea7c1b34947ce6933184"
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
