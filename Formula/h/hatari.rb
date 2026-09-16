class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://www.hatari-emu.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://framagit.org/hatari/releases/-/raw/main/v2.6.1/hatari-2.6.1.tar.bz2"
    sha256 "b7dc09ebffc1b77da6837d37b116bc5a9b2fd46affff1021124101e3f6e76bc5"
    depends_on "sdl2-compat"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "59c4605bc0598ee25df898492190eeaf8156d177ffb41529b830d1df1c08fa4d"
    sha256 cellar: :any,                 arm64_sequoia: "d9b000457bb9dc9d31b05fe5dfeeac62b817142d98d974c9337f54d803ce4fb5"
    sha256 cellar: :any,                 arm64_sonoma:  "021a7f31239d351dbb0a0872e5dceb0d60929f0131de8ca2e6a44bb8923799f0"
    sha256 cellar: :any,                 sonoma:        "306b691f4301f03902b61716da6532a5fdff119e88a58f51893a62855270ed19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f9133ea1e05b9d5fa6328e6b780a93be6cb682cc45c6deba48e6c9e4e6fae19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab439d6a576b5afe27ad1546ffe23fab4bc7cc8ec92ac71fef92dc098c48182"
  end

  head do
    url "https://framagit.org/hatari/hatari.git", branch: "main"
    depends_on "sdl3"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  on_linux do
    depends_on "libx11"
    depends_on "readline"
    depends_on "zlib-ng-compat"
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
    if OS.mac?
      args = %W[
        -DCMAKE_DISABLE_FIND_PACKAGE_X11=ON
        -DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}
        -DENABLE_OSX_BUNDLE=OFF
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("emutos").stage do
      pkgshare.install "etos1024k.img" => "tos.img"
    end
  end

  test do
    assert_match "Hatari v#{version} -", shell_output("#{bin}/hatari -v", 1)
  end
end
