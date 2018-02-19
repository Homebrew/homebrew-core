class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.1.0/hatari-2.1.0.tar.bz2"
  sha256 "eb299460e92db4a8a2983a0725cbbc8c185f1470b8ecd791b3d102815da20924"
  head "https://hg.tuxfamily.org/mercurialroot/hatari/hatari", :using => :hg, :branch => "default"

  bottle do
    cellar :any
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "portaudio"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/0.9.9.1/emutos-512k-0.9.9.1.zip"
    sha256 "ab94cd249aebd7fb1696cbd5992734042450d8b96525f707e9ad8a2283185341"
  end

  if MacOS.verion <= :high_sierra
    patch do
      url "url du patch"
      sha256 "41da2a89fe28bfe145cd788844c83c6a856e01dc7b83cb72af7c281a3bedd65a"
    end
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
