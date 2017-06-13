class Angolmois < Formula
  desc "BM98-like rhythm game"
  homepage "https://mearie.org/projects/angolmois/"

  stable do
    url "https://github.com/lifthrasiir/angolmois/archive/angolmois-2.0-alpha2.tar.gz"
    version "2.0.0alpha2"
    sha256 "97ac3bff8a4800a539b1b823fd1638cedbb9910ebc0cc67196ec55d7720a7005"
    depends_on "sdl"
    depends_on "sdl_image"
    depends_on "sdl_mixer" => "with-smpeg"
    depends_on "smpeg"
  end

  bottle do
    cellar :any
    sha256 "da65bae7959ac500d64aa1945419beff9a77693bf3772768b518229c6f874192" => :sierra
    sha256 "6d9087464b1337d8c08223b71fe08ff7aee1f1ce3a394e1bb91ade6417ece9b4" => :el_capitan
    sha256 "003f6de7f268fe9e07379a6ad0b2166e7dcd521c8141a2062060d84d20dbf6d5" => :yosemite
  end

  head do
    url "https://github.com/lifthrasiir/angolmois.git"
    depends_on "sdl2"
    depends_on "sdl2_image"
    depends_on "sdl2_mixer" => "with-smpeg2"
    depends_on "smpeg2"
  end

  depends_on "pkg-config" => :build

  def install
    system "make"
    bin.install "angolmois"
  end

  test do
    assert_equal version.to_s, /Angolmois (\d+\.\d+(?:\.\d+)?) (\w+) (\d+)?/.match(shell_output("#{bin}/angolmois --version")).to_a.drop(1).join
  end
end
