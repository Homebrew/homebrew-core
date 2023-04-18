class Mcpp < Formula
  desc "Alternative C/C++ preprocessor"
  homepage "https://mcpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz"
  sha256 "3b9b4421888519876c4fc68ade324a3bbd81ceeb7092ecdbbc2055099fcb8864"

  livecheck do
    url :stable
    regex(%r{url=.*?/mcpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1c08275021d44b1db481d2f802ce2b69da952ea4afe04e1a0ce9ae36243f08f1"
    sha256 cellar: :any,                 arm64_monterey: "506e27459d6f4f9fc296bcf826d113aaa659fc814f11419fa484bf38ec94888d"
    sha256 cellar: :any,                 arm64_big_sur:  "b6b90e4e5f4b50a390a5cbd6d2c6664dd8d3212013e469c9d3c90d5bf67a774c"
    sha256 cellar: :any,                 ventura:        "69aad3cd745bb5fb369475a44ac532848d2cedee77a832552cff37f522b19469"
    sha256 cellar: :any,                 monterey:       "fb4dbfea519b3df6d1b10a769ac1f25f53fccda42d2112602a9dcd2eee7bd791"
    sha256 cellar: :any,                 big_sur:        "ba1468299782ecb1de53cff2390096e7300f5c8f021cef623544d969a37240df"
    sha256 cellar: :any,                 catalina:       "742a861cb7087caedaed90aa40c4780a1e6e4ad50be74ee64b251c6ae1ebe21c"
    sha256 cellar: :any,                 mojave:         "40a63165c2df3feab3ed58c09a3f4b60daef5e112ec2f101f056aee56ca9819f"
    sha256 cellar: :any,                 high_sierra:    "fe1489ca47b0d9e551b4aa1b6cb2a4135848be79e3982856442080f75fcb45d7"
    sha256 cellar: :any,                 sierra:         "cdd368c63dc6403832c938967f8f099ec3d02acfcc5c75ab0426ad1cd213b045"
    sha256 cellar: :any,                 el_capitan:     "0be73930b3dbc8bc247c9a26acbc6115d3f5f665daaabc9ab64606ac6793ace9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7869ff9d2c9946dd38a7891ea70766983208df755ca0f206016211b3239701c8"
  end

  # stpcpy is a macro on macOS; trying to define it as an extern is invalid.
  # Patch from ZeroC fixing EOL comment parsing
  # https://forums.zeroc.com/forum/bug-reports/5445-mishap-in-slice-compilers?t=5309
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3fd7fba/mcpp/2.7.2.patch"
    sha256 "4bc6a6bd70b67cb78fc48d878cd264b32d7bd0b1ad9705563320d81d5f1abb71"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mcpplib"
    system "make", "install"
  end
end
