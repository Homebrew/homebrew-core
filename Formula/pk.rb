class Pk < Formula
  desc "Field extractor command-line utility"
  homepage "https://github.com/johnmorrow/pk"
  url "https://github.com/johnmorrow/pk/releases/download/v1.0.2/pk-1.0.2.tar.gz"
  sha256 "0431fe8fcbdfb3ac8ccfdef3d098d6397556f8905b7dec21bc15942a8fc5f110"

  bottle do
    cellar :any_skip_relocation
    sha256 "790f7e9670dcda15b7472264eea54666e7e34e8adb4343b3699ab87a60c9f3b1" => :sierra
    sha256 "74c7822b2e3a74bc657d5e8490f184af120eddf9230695fe26dbb075391e10e6" => :el_capitan
    sha256 "2e86bd1b33521a5856308b58ab35f7384988e9cb6506a4f3d9191ea38361235d" => :yosemite
    sha256 "29897298823bb20019ab5f608e1e6f2c8189076a5c0097d5f09eb504e6e814bf" => :mavericks
  end

  depends_on "argp-standalone"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_equal "B C D", pipe_output("#{bin}/pk 2..4", "A B C D E", 0).chomp
  end
end
