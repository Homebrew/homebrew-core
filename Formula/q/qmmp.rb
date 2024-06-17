class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.1/qmmp-2.1.8.tar.bz2"
  sha256 "846a6143c7a9ab29b8ec2f5da2248e41ddf2736f17c15d94b0d73b8af85a69ee"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9f66cd4552a1e0ebf47f042bfa4aee8da347f8496491a5a74b174ac65c7f3637"
    sha256 arm64_monterey: "9611fcdd44de2fd101761a5609bd5aeb99b16296c7aff5d4848a069293b83182"
    sha256 ventura:        "84c4b219c07b6aa338e3d1d92c4d3b35e23579df2e3e1fbf049d5c63438290f7"
    sha256 monterey:       "b560ee9657fe34e1adfb9d83928223a4aeb9378a659c2b775d32641c2de55d71"
    sha256 x86_64_linux:   "87e0e32e3a5a2f4ad894bb373cc64e1a54ae140c350ce996215353ef2317dd38"
  end

  depends_on "cmake"      => :build
  depends_on "pkg-config" => :build

  # TODO: on linux: pipewire
  depends_on "faad2"
  depends_on "ffmpeg@6"
  depends_on "flac"
  depends_on "game-music-emu"
  depends_on "jack"
  depends_on "libarchive"
  depends_on "libbs2b"
  depends_on "libcddb"
  depends_on "libcdio"
  depends_on "libmms"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "libxcb"
  depends_on "libxmp"
  depends_on "mad"
  depends_on "mplayer"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "projectm"
  depends_on "pulseaudio"
  depends_on "qt"
  depends_on "taglib"
  depends_on "wavpack"
  depends_on "wildmidi"

  uses_from_macos "curl"

  on_macos do
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.1/qmmp-plugin-pack-2.1.1.tar.bz2"
    sha256 "f68484426579f2a0bc68b6be06e7a019fd1c266fca35b764d5788661ddf9bcc4"
  end

  def install
    cmake_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DUSE_SKINNED=ON
      -DUSE_ENCA=ON
      -DUSE_QMMP_DIALOG=ON
    ]
    if OS.mac?
      cmake_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
      cmake_args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup"
    end

    system "cmake", "-S", ".", *cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    resource("qmmp-plugin-pack").stage do
      system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    system bin/"qmmp", "--version"
  end
end
