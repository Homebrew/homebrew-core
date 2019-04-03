class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.2.1/hatari-2.2.1.tar.bz2"
  sha256 "11afef30a274be84696588583d5a1d65c8046934670f718c311c956ef7106f60"
  head "https://git.tuxfamily.org/hatari/hatari.git"

  bottle do
    cellar :any
    sha256 "3c13b288119a92d537856f07fd1dc8086778560659acfc84a228891bf2e11709" => :mojave
    sha256 "8ae0f75f55becb21fcedb5dd1d06925624d911088e5eebec85f284411406622b" => :high_sierra
    sha256 "51da79162122d274d22bb54e08d3c6e9c2fffa561da57800af6342f081ed621f" => :sierra
    sha256 "ab91725ffc7378cafd715b5d357fae4a0efcba481a28062ec267b880f56191fd" => :el_capitan
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
