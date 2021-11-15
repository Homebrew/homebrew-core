class Clzip < Formula
  desc "C language version of lzip"
  homepage "https://www.nongnu.org/lzip/clzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/clzip/clzip-1.12.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/clzip/clzip-1.12.tar.gz"
  sha256 "fcc92b3006d87b7c4affa03fe9dcc4869a802253052653200c26f6ba718bfee8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/clzip/"
    regex(/href=.*?clzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3907dfa594ee7d6d237ae118fade57365a6c1318379da8ea709845ffca68af76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ae403fecae4e6688b40662a5160f7fbc55e5636ce1a9447dba83c14c60e825f"
    sha256 cellar: :any_skip_relocation, monterey:       "23691b3d00a35a10480592393ab1c3442950e663768369d64f09df09a3a63b4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e82b38513ecfa60b53ea584aa573682fd4b7df5db3e45ccbe633840258f547ee"
    sha256 cellar: :any_skip_relocation, catalina:       "dc96f1ee14b4b904dd1ecfef38cb3fae30cefd7b490eb31b78e57942df72c2b9"
    sha256 cellar: :any_skip_relocation, mojave:         "d4cbf4b08330488cf80bbdf6c16d740038c72028760e1bba043122f217e00721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a1ea519aedf9b7ad116ad71caf65ca8fa08f2b0f444945f8127c6faf05fa6c6"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "testsuite"
  end

  test do
    cp_r pkgshare/"testsuite", testpath
    cd "testsuite" do
      ln_s bin/"clzip", "clzip"
      system "./check.sh"
    end
  end
end
