class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.19.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/colordiff-1.0.19.tar.gz"
  sha256 "46e8c14d87f6c4b77a273cdd97020fda88d5b2be42cf015d5d84aca3dfff3b19"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?colordiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "945737122c0c542218c0ab89a1e923174033f27dd92760f102ca38c565c5485d" => :big_sur
    sha256 "bef827804516409457baf7bd7a7622d595aa6c2ace53c011400fbdcf54850755" => :arm64_big_sur
    sha256 "a591ec70f59b8f5ff3cde4c0a8cd58d920db324f9c3001e218bdcfc8966aca15" => :catalina
    sha256 "f5b78a778860c7d37a370287c3821e17243a37e5e568cf58fd2aa3df3e3ce409" => :mojave
    sha256 "305a7dfd6940d463d89473c1f2864c5f5b1bd7ed01f838929c3901ad94f4586d" => :high_sierra
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
