class Dieharder < Formula
  desc "Random number test suite"
  homepage "https://www.phy.duke.edu/~rgb/General/dieharder.php"
  url "https://www.phy.duke.edu/~rgb/General/dieharder/dieharder-3.31.1.tgz"
  sha256 "6cff0ff8394c553549ac7433359ccfc955fb26794260314620dfa5e4cd4b727f"
  revision 3

  bottle do
    cellar :any
    sha256 "3f53c783d640819b446cbf91c3293d47aa0b0c334a630d25f2c5b5b514aeb844" => :catalina
    sha256 "b7b1bdbb6f105e4286320ad067689d8e3f7a2c7821a53382ebc2007b47d06dc9" => :mojave
    sha256 "341bdf1e0fce90d69db4e6749ec3ee3b8c5903559e365a19e9f5a8ba2723d403" => :high_sierra
    sha256 "8a40fb61aef5230ad77b3b851a6e8b6d575ff2adaa747c3b73a75cd203197945" => :sierra
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
