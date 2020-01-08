class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.2.1/hatari-2.2.1.tar.bz2"
  sha256 "11afef30a274be84696588583d5a1d65c8046934670f718c311c956ef7106f60"
  head "https://git.tuxfamily.org/hatari/hatari.git"

  bottle do
    cellar :any
    sha256 "b7117341420c778b9d58b05551c59f214ef22c60ec3b94dcbcd7ce9bfd404ceb" => :catalina
    sha256 "c0a3104dfa4cbaf4fd4d740606f79d5a1813e1721fd0df39864d3e5f68b81648" => :mojave
    sha256 "297be94b3f4d81ab53b00e9ed5918b62c6de3d80a70b9c17b1dc364b0e52a75d" => :high_sierra
    sha256 "e9059ebf74999ffdd7737aa36a9cbde52766ac0187a3b94074b79ffd5ab49977" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "portaudio"
  depends_on "sdl2"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/0.9.10/emutos-512k-0.9.10.zip"
    sha256 "773bbbfc418827d863c313c4f1d3c73ef3d296c5f23b4d00ee4f38f080a9c255"
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
