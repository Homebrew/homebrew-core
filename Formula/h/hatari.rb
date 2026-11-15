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
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "8b15bbe1d2952a755d91c6041b914bdcd81dc884084b867890adbc8091101c48"
    sha256 cellar: :any, arm64_tahoe:       "fa9f0afbe42a4c1f9f2cdf6f75cca0aa9b574780ed5e2f3ef4a6ae4c646d9a33"
    sha256 cellar: :any, arm64_sequoia:     "d2ae1893a8569d6f16a465eb1e9d5785c39f9192a83abcd0d367e5bc13dcd726"
    sha256 cellar: :any, arm64_linux:       "02f7b9bf697d9b09c1097565393b12c0ae527a885dc54ae1410fb4d5ca61a77a"
    sha256 cellar: :any, x86_64_linux:      "2d440e9158df9418c060a1907b8bc759957c54c9fcb4f1c87086d15d90ec09ff"
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

  deny_network_access!

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
