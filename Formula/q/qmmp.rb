class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.3/qmmp-2.3.0.tar.bz2"
  sha256 "01c3e30367c885178cd115594d20f694a47a352fd7e65fcf5722e12ac8333063"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e6da5eb38b48ffe1d8f40676be1444e840c833c3311f7a631ca9762694e81aad"
    sha256 cellar: :any,                 arm64_sequoia: "7fa781c7162c07690e998ab6c9d598f24115ceedca718bd12528c15b96d243ed"
    sha256 cellar: :any,                 arm64_sonoma:  "3fc459eb502ada770aa7fbfcc3e0e311bdea4f39d6ff4d4b341453b01ba4a948"
    sha256 cellar: :any,                 sonoma:        "0a74c8a1511f9c9347723a0d6a478fb0d9a93604649804f5011310ea4a5b4a2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe28066049c5fc79e28a19dd8aced21f78deaa12fecfbfb017a827a7aba2e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a643156b0ee13bbeb993e38550a14fe2c367de12828fa8a18cf7db7e5e083531"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

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
  depends_on "musepack"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "projectm"
  depends_on "pulseaudio"
  depends_on "qtbase"
  depends_on "qtmultimedia"
  depends_on "taglib"
  depends_on "wavpack"
  depends_on "wildmidi"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "mesa"
  end

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.3/qmmp-plugin-pack-2.3.0.tar.bz2"
    sha256 "a23c202f90faaf6aebb97a9c02ee21fb3c8164b07755514349ccb3e1acb81ab5"

    livecheck do
      url "https://qmmp.ylsoftware.com/plugins.php"
      regex(/href=.*?qmmp-plugin-pack[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
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
