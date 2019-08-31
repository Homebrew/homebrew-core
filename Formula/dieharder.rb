class Dieharder < Formula
  desc "Random number test suite"
  homepage "https://www.phy.duke.edu/~rgb/General/dieharder.php"
  url "https://www.phy.duke.edu/~rgb/General/dieharder/dieharder-3.31.1.tgz"
  sha256 "6cff0ff8394c553549ac7433359ccfc955fb26794260314620dfa5e4cd4b727f"
  revision 3

  bottle do
    cellar :any
    sha256 "c02799fe41057f9de24178686e7cce9666d6e5650104a41a8955d7af2461ef2f" => :mojave
    sha256 "f1f36b404203561f04b05aef3bce6f483980eee5ee8898b1f535ccade28ef369" => :high_sierra
    sha256 "758c782ab9ba74df2bf493296435eafc24b97fdda7493485bf367f4afd7a50e7" => :sierra
    sha256 "7adbcdbabc0c75df4394b7934dc5d8b33ef325ebf58a082e061fc333b0f82b1d" => :el_capitan
    sha256 "c401b110311adafced06a2e5dc61b1ae2d159cfdf749b9b8835b791487facd33" => :yosemite
  end

  depends_on "gsl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-shared"
    system "make", "install"
  end

  test do
    system "#{bin}/dieharder", "-o", "-t", "10"
  end
end
