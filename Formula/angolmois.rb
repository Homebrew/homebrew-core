class Angolmois < Formula
  desc "BM98-like rhythm game"
  homepage "http://mearie.org/projects/angolmois/"

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
    sha256 "da08947ee8e73da3a850420332b6c0961e0aee1b9d1a5f44e7653ded789a8bb5" => :el_capitan
    sha256 "b23d0e9091916d0a82be335af3eea1cf46b63de95b0c844d486ff5ff5ae45247" => :yosemite
    sha256 "e48b08dafd1f8022fd72e1a1e634fb5c47c1ef3430689869c1dffa7585c6148a" => :mavericks
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
