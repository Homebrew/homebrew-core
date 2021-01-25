class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.3.1/hatari-2.3.1.tar.bz2"
  sha256 "44a2f62ca995e38d9e0874806956f0b9c3cc84ea89e0169a63849b63cd3b64bd"
  license "GPL-2.0-or-later"
  head "https://git.tuxfamily.org/hatari/hatari.git"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "485738be593ab647a5543878cf748d4602f9123b053fef63672f31a271009700" => :big_sur
    sha256 "8606d3d0c17b73205030593e2b2a3cd0ea1a87fbcb7998b2d84bba14e67957f1" => :arm64_big_sur
    sha256 "9137d6022e24772be5ef1af60ecd2fc9441a690cea63cd9509b3c9619a88d303" => :catalina
    sha256 "c88fc0f38bb911d3d7ef419a176118bfa3de9f3e9db4b1ab8c3d1644fe75c039" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "portaudio"
  depends_on "python@3.9"
  depends_on "sdl2"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.0.1/emutos-512k-1.0.1.zip"
    sha256 "96c698aa0fc0f51ecdb0f8b53484df9de273215467b5de3f44d245821dff795e"
  end

  def install
    # Set .app bundle destination
    inreplace "src/CMakeLists.txt", "/Applications", prefix
    system "cmake", *std_cmake_args, "-DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3"
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
