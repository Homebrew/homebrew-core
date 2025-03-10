class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.2/qmmp-2.2.3.tar.bz2"
  sha256 "993e57d8e11b083bb6f246738505edf35d498ffe82a1936f3129b8bb09eab244"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "24a3a45737a94147fce75d1630df1b1d028c0742bd67c9c3ddf4eb499e2787a4"
    sha256 cellar: :any,                 arm64_ventura: "c9986e043bc2e4bebe7f21ade88566e215d986b249831dae16a2c3e25bf23fe8"
    sha256 cellar: :any,                 sonoma:        "c3cd2a1a053eeb4c5c82e687d3136bde8dcce8d4d051ed3f42da4a6fe56ee361"
    sha256 cellar: :any,                 ventura:       "34c2c7f43fc5dd5b485bcc681d590a66dbcff4b55ff29b7517e45ff85c2c48a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e28d6b699b0e33896350fd20cbd58ff26f4cfb1f7a83ee942b8f3ac5cdf6ed"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  # TODO: on linux: pipewire
  depends_on "faad2"
  depends_on "ffmpeg"
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
  depends_on "mpg123"
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
    depends_on "gettext"
    depends_on "glib"
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "mesa"
  end

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.2/qmmp-plugin-pack-2.2.1.tar.bz2"
    sha256 "bfb19dfc657a3b2d882bb1cf4069551488352ae920d8efac391d218c00770682"
  end

  # add taglib 2.x support
  patch do
    url "https://sources.debian.org/data/main/q/qmmp/2.2.3-1/debian/patches/0002-Fix-taglib-2.x-compatibility.patch"
    sha256 "837bea7d6af9dc0be072b450f74ce9382ae1c7963d2e4a78c9eb2208b283ea62"
  end

  def install
    cmake_args = %W[
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

    # Fix to recognize x11
    # Issue ref: https://sourceforge.net/p/qmmp-dev/tickets/1177/
    inreplace "src/plugins/Ui/skinned/CMakeLists.txt", "PkgConfig::X11", "${X11_LDFLAGS}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    ENV.append_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    resource("qmmp-plugin-pack").stage do
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    system bin/"qmmp", "--version"
  end
end
