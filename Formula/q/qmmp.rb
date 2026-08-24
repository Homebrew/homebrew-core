class Qmmp < Formula
  desc "Qt-based Multimedia Player"
  homepage "https://qmmp.ylsoftware.com/"
  url "https://qmmp.ylsoftware.com/files/qmmp/2.4/qmmp-2.4.1.tar.bz2"
  sha256 "5a0a6f1efcefe9cc4b1ff3ae4038493168baec0b12989ca116af2454098825ed"
  license "GPL-2.0-or-later"
  livecheck do
    url "https://qmmp.ylsoftware.com/downloads.php"
    regex(/href=.*?qmmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "276178bf99fe69d2fae0fefa443c563d152745cfe01e9ae6db54a4ff317ac829"
    sha256 cellar: :any, arm64_sequoia: "9034999d2a1c33e46579765bf99ff5959ff0defe3a8212e52d1ee1d640bdc940"
    sha256 cellar: :any, arm64_sonoma:  "24b1534c1c76493649bcdedb43cd7eb0c24b83899a5c5704f28205e95f692d38"
    sha256 cellar: :any, sonoma:        "8e83ed18c88da9da94d6d1729c81b3e888d0d55ed9b69198baa6299f98ec6a4c"
    sha256 cellar: :any, arm64_linux:   "64b0ddf373ae9eb836a5dc17ea35569d0cde3acd8eaea6013e988203bde99d99"
    sha256 cellar: :any, x86_64_linux:  "d5b4a197102fba122adfb8950d5c2e20ad650db097bb6d6c7f76915e07ed6140"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "game-music-emu"
  depends_on "jack"
  depends_on "libarchive"
  depends_on "libbs2b"
  depends_on "libcddb"
  depends_on "libcdio"
  depends_on "libcdio-paranoia"
  depends_on "libmms"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
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
    depends_on "libxcb"
    depends_on "mesa"
    depends_on "pipewire"
  end

  resource "qmmp-plugin-pack" do
    url "https://qmmp.ylsoftware.com/files/qmmp-plugin-pack/2.4/qmmp-plugin-pack-2.4.0.tar.bz2"
    sha256 "db677a522b6755bb6281ea18ed5ecf994d87bce61ca0e82a3bb47c8f7c119dd7"

    livecheck do
      url "https://qmmp.ylsoftware.com/plugins.php"
      regex(/href=.*?qmmp-plugin-pack[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  def install
    rpaths = [rpath, "#{loader_path}/../.."]
    cmake_args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
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
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}", *std_cmake_args
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
