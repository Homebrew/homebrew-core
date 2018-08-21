class Mcpp < Formula
  desc "Alternative C/C++ preprocessor"
  homepage "https://mcpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz"
  sha256 "3b9b4421888519876c4fc68ade324a3bbd81ceeb7092ecdbbc2055099fcb8864"

  bottle do
    cellar :any
    rebuild 1
    sha256 "40a63165c2df3feab3ed58c09a3f4b60daef5e112ec2f101f056aee56ca9819f" => :mojave
    sha256 "fe1489ca47b0d9e551b4aa1b6cb2a4135848be79e3982856442080f75fcb45d7" => :high_sierra
    sha256 "cdd368c63dc6403832c938967f8f099ec3d02acfcc5c75ab0426ad1cd213b045" => :sierra
    sha256 "0be73930b3dbc8bc247c9a26acbc6115d3f5f665daaabc9ab64606ac6793ace9" => :el_capitan
    sha256 "612e3efb23a8165af204338a20bbc27ae8fa2ad345964c24d2d7a206dee0317a" => :yosemite
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
