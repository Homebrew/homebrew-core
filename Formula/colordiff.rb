class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/colordiff-1.0.19.tar.gz"
  sha256 "46e8c14d87f6c4b77a273cdd97020fda88d5b2be42cf015d5d84aca3dfff3b19"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?colordiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f0433560a0417e350a57ad24a80d277cb3cc2665046a10d8db630ef432529603" => :catalina
    sha256 "f0433560a0417e350a57ad24a80d277cb3cc2665046a10d8db630ef432529603" => :mojave
    sha256 "f0433560a0417e350a57ad24a80d277cb3cc2665046a10d8db630ef432529603" => :high_sierra
  end

  depends_on "coreutils" => :build # GNU install

  conflicts_with "cdiff", because: "both install `cdiff` binaries"

  def install
    man1.mkpath
    system "make", "INSTALL=ginstall",
                   "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp HOMEBREW_PREFIX+"bin/brew", "brew1"
    cp HOMEBREW_PREFIX+"bin/brew", "brew2"
    system "#{bin}/colordiff", "brew1", "brew2"
  end
end
