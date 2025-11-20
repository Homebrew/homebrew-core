class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://www.hatari-emu.org/"
  url "https://framagit.org/hatari/releases/-/raw/main/v2.6.1/hatari-2.6.1.tar.bz2"
  sha256 "b7dc09ebffc1b77da6837d37b116bc5a9b2fd46affff1021124101e3f6e76bc5"
  license "GPL-2.0-or-later"
  head "https://framagit.org/hatari/hatari.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4f44d0f0dbbeb91103358654e2245b4fb5247d5a2f8a55bd0f12c5f4adadb11"
    sha256 cellar: :any,                 arm64_sequoia: "ac0f9543aa27fd9ffb4f8c851aadd6580f422fb229b8c31dc97b22b103fbf92c"
    sha256 cellar: :any,                 arm64_sonoma:  "a307fd095b1b81bc0f4eed6fbd8a38d391376a829f0c4a8e4ecc1a10e31273ec"
    sha256 cellar: :any,                 arm64_ventura: "ba4c9fa53fa9fdb33a414bc684c5d5e49ed824048ebba965333a4b2c608d1cbf"
    sha256 cellar: :any,                 sonoma:        "66661487e216585adfb19d06e8ca0a672e94de6e73266176c59135e10cc4dda1"
    sha256 cellar: :any,                 ventura:       "b22ddd5646e89645736295faf54208b1a8463b05420b99511d48dc3d68dc5833"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422f6cd17e5bd06a050e5555f962ca1c4292dc91a77c9128e9ae0383804e1368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7beccd3db794c33686a6a57b6f96eb764e698dcc10bb0c24af17e1aa97c666a"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "readline"
  end

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.4/emutos-1024k-1.4.zip"
    sha256 "dc9fbef6455a24ee8955cccd565588c718ba675fd54bc5a749003ac4bbd7f7e1"

    livecheck do
      url "https://sourceforge.net/projects/emutos/rss?path=/emutos"
      regex(%r{/emutos[._-]1024k[._-](\d+(?:\.\d+)+)\.z}i)
    end
  end

  def install
    # Set .app bundle destination
    inreplace "src/CMakeLists.txt", "/Applications", prefix
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}", *std_cmake_args
    system "cmake", "--build", "build"
    if OS.mac?
      prefix.install "build/src/Hatari.app"
      bin.write_exec_script prefix/"Hatari.app/Contents/MacOS/hatari"
    else
      system "cmake", "--install", "build"
    end
    resource("emutos").stage do
      datadir = OS.mac? ? prefix/"Hatari.app/Contents/Resources" : pkgshare
      datadir.install "etos1024k.img" => "tos.img"
    end
  end

  test do
    assert_match "Hatari v#{version} -", shell_output("#{bin}/hatari -v", 1)
  end
end
