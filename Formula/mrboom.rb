class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.1/MrBoom-src-5.1.tar.gz"
  sha256 "776fc2998825f8234bc57d0ab243c2f29b5ab888763d7fb066e6b839c99a4054"
  license "MIT"

  bottle do
    cellar :any
    sha256 "6531998d0edc841a0070135bad1f06910c2b7bc039db508562dedc0bcc054502" => :catalina
    sha256 "ccbe19edffde88813ff3ab4657f449ccbb366d536b3b52cc81fde1a1959bd0da" => :mojave
    sha256 "d50267a32f6fd8e9d181c0d857f2b04343702cca3d540bb14f033ee66fcf589f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # gui app
    assert_match "Set joysticks dead zone, default is 8000",
      shell_output("#{bin}/mrboom --help")
  end
end
