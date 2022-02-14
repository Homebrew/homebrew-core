class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.20.tar.gz"
  sha256 "e3b2017beeb9f619ebc3b15392f22810c882d1b657aab189623cffef351d7bcd"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?colordiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "074e293f6918138f532ee761a97822b75344fba0bf1193c776b597e40b7763ca"
  end

  depends_on "coreutils" => :build # GNU install

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
