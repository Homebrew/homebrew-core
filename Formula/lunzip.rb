class Lunzip < Formula
  desc "Decompressor for lzip files"
  homepage "https://www.nongnu.org/lzip/lunzip.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lunzip/lunzip-1.13.tar.gz"
  sha256 "3c7d8320b947d2eb3c6081caf9b6c91b12debecb089ee544407cd14c8e517894"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lunzip/"
    regex(/href=.*?lunzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6462f46ff95d636d96c050ffdaf20f0262d59b318cdbac85fb624ad61793af8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec4ca457cb4a253c5d55639b78d161eb3d7bc5049b255d2bce7f05944b84553a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02f528b366f19bdff196bc9a6b56bb04391269eed41b5bee551b47bd7697f88e"
    sha256 cellar: :any_skip_relocation, ventura:        "0ec7bd681206ccfa57d4a5aa6b2866fe68c9644d6bb1f0bd76f35dfcd5ea1df5"
    sha256 cellar: :any_skip_relocation, monterey:       "4fe478003ec28e042575db9a551c673a97f73a4aeda30cb58e6a3f7158100a03"
    sha256 cellar: :any_skip_relocation, big_sur:        "b147bdc3ce46250190565ac18843bfc7013e01e1556187653ef40fee5a072e5d"
    sha256 cellar: :any_skip_relocation, catalina:       "bf47470a86fb1b9e345dd77d4dfea86a636bc13f18b2e12baf95590d38fa125d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f713d18ae891d3b1b3dbb1731a5b0b42ad5b72b0d16e6a3b4936c098b619bab4"
  end

  depends_on "lzip" => :test

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system Formula["lzip"].opt_bin/"lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system bin/"lunzip", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
