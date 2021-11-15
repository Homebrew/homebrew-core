class Dieharder < Formula
  desc "Random number test suite"
  homepage "https://webhome.phy.duke.edu/~rgb/General/dieharder.php"
  url "https://webhome.phy.duke.edu/~rgb/General/dieharder/dieharder-3.31.1.tgz"
  sha256 "6cff0ff8394c553549ac7433359ccfc955fb26794260314620dfa5e4cd4b727f"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?dieharder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "8f2ff1ac4cb2864c3352459c687c2a820f487200be88888161c5781f3548f131"
    sha256 cellar: :any, arm64_big_sur:  "e0650468410dbd840acddb2cebc9e28e7bdd0293d5c442abb8c95d50c8524735"
    sha256 cellar: :any, monterey:       "e05816267d13a70694f9a5618c959ef02e7a2f60ff6110eb1c4628a3a640b4b2"
    sha256 cellar: :any, big_sur:        "24603f6e3c5376e294cdcd0d94cc045e48dec3402fd69a3b927ec1291f7b5c26"
    sha256 cellar: :any, catalina:       "3f53c783d640819b446cbf91c3293d47aa0b0c334a630d25f2c5b5b514aeb844"
    sha256 cellar: :any, mojave:         "b7b1bdbb6f105e4286320ad067689d8e3f7a2c7821a53382ebc2007b47d06dc9"
    sha256 cellar: :any, high_sierra:    "341bdf1e0fce90d69db4e6749ec3ee3b8c5903559e365a19e9f5a8ba2723d403"
    sha256 cellar: :any, sierra:         "8a40fb61aef5230ad77b3b851a6e8b6d575ff2adaa747c3b73a75cd203197945"
  end

  depends_on "gsl"

  on_linux do
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b5dfa6f2b9c5d44cb4bab93ace2e0d7d58465fb0/dieharder/dieharder-linux.patch"
      sha256 "8c0ab2425c8a315471f809d5ecaebd061985f24019886cba7f856e5aaf72112b"
    end
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-shared"
    system "make", "install"
  end

  test do
    system "#{bin}/dieharder", "-o", "-t", "10"
  end
end
