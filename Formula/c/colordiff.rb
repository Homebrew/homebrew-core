class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.22.tar.gz"
  sha256 "93a9f8b83a19cd61d1f7f306f8ddebea8f5ea11f3a4d236ec843ba50cea58dea"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?colordiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0925b7ca0eb5b58f2cf3f85f7354eb1f57bdc5114c3d509c829abf1df7479dec"
  end

  depends_on "coreutils" => :build # GNU install

  def install
    man1.mkpath
    system "make", "INSTALL=ginstall",
                   "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"

    inreplace bin/"colordiff", "/usr/local", HOMEBREW_PREFIX if OS.mac? && Hardware::CPU.intel?
  end

  test do
    cp HOMEBREW_PREFIX/"bin/brew", "brew1"
    cp HOMEBREW_PREFIX/"bin/brew", "brew2"
    system bin/"colordiff", "brew1", "brew2"
  end
end
