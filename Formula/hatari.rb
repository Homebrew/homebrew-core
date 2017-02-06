class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.0.0/hatari-2.0.0.tar.bz2"
  sha256 "52a447a59b6979d55d1525f3c4a21ec013e4371354d6683ede71546c5e6da577"
  head "https://hg.tuxfamily.org/mercurialroot/hatari/hatari", :using => :hg, :branch => "default"

  bottle do
    cellar :any
    sha256 "33cb425e5dfc9a746ae0a003e7de76bd0f0ab7c48d57f90fd7f7cab1f97be586" => :sierra
    sha256 "96e75e0d2235ead48758ef5dd11d1ecc1e5415190d8c521fd5b26f329673a738" => :el_capitan
    sha256 "443350d22e25674a03d149e313c17974cb44eed80c30a7dfab89410b7d748caf" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "portaudio"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/0.9.6/emutos-512k-0.9.6.zip"
    sha256 "2c7d57cac6792d0c7e921f9655f224b039402283dd24c894b085c7b6e9a053a6"
  end

  def install
    # Set .app bundle destination
    inreplace "src/CMakeLists.txt", "/Applications", prefix
    system "cmake", *std_cmake_args
    system "make"
    prefix.install "src/Hatari.app"
    bin.write_exec_script "#{prefix}/Hatari.app/Contents/MacOS/hatari"
    resource("emutos").stage do
      (prefix/"Hatari.app/Contents/Resources").install "etos512k.img" => "tos.img"
    end
  end

  test do
    assert_match /Hatari v#{version} -/, shell_output("#{bin}/hatari -v", 1)
  end
end
