class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.3.0/hatari-2.3.0.tar.bz2"
  sha256 "bf48161903930f6470eca1d9c293f51b09b8c54695f5ee213af141316253b8a5"
  license "GPL-2.0-or-later"
  head "https://git.tuxfamily.org/hatari/hatari.git"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "0baa34a4ce8960b24721e9423b9b3cf37c221a7ccba2aee3f948ecbf453daeea" => :big_sur
    sha256 "e7c5b6bfc5fe993acf0965cf8ba9ee9800ad1134dcc6fd1bacc302cdb8a3dd46" => :arm64_big_sur
    sha256 "e6bfde29e08aa400d154cdab01046f54d585c74355dc1c81d3c42d4699df9c63" => :catalina
    sha256 "b645bf65c98e346c1ba31d8d4b2d04ea3e51ca0f602d57382746fe820f8b860e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "portaudio"
  depends_on "python@3.9"
  depends_on "sdl2"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/0.9.10/emutos-512k-0.9.10.zip"
    sha256 "773bbbfc418827d863c313c4f1d3c73ef3d296c5f23b4d00ee4f38f080a9c255"
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
