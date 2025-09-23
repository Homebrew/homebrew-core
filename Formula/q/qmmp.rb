class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.2/qmmp-2.2.8.tar.bz2"
  sha256 "730a97a063a498eb37da9e2f8198dfe570693e6a6c7f2b210d581bd87dbb938a"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "8ee64ac53b6d3dcc276d7e68485a41c944493932bb03c11dab019192b8e4d3c7"
    sha256 cellar: :any,                 arm64_ventura: "091abe456fce70bebecd6c52dbc29023834b168b4ebce8965a7eec7376bad5e4"
    sha256 cellar: :any,                 sonoma:        "e53841142aef6797006007106b28c75b135cf8cc2e2ab480cdc6c410cf2b7b97"
    sha256 cellar: :any,                 ventura:       "9a6a1c5b18814608aba6ac5cab4b6831da5e5ddff4c911fb2992651cc9fc7f73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "937dffeceab76262364fb117c6e428a5b3509852266556ec7be2d71544f1afdf"
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
  depends_on "musepack"
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
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "mesa"
  end

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.2/qmmp-plugin-pack-2.2.2.tar.bz2"
    sha256 "0e85c8290b49aceddb7a52f9452d9c0c008539b6fba4ab2296b59a67d0b0846b"

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
