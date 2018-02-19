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

  # Fix build by providing missing NSAlertStyleInformational
  # Remove in next version.
  patch do
    url "https://hg.tuxfamily.org/mercurialroot/hatari/hatari/raw-rev/21bc2b0ebae4"
    sha256 "0d6ca48030749061246d5edbf61e4bf2ad0311d5f004c1df8bee1d662b581dc6"
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
