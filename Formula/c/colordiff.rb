class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "https://www.colordiff.org/"
  url "https://www.colordiff.org/colordiff-1.0.22.tar.gz"
  sha256 "f96f73c54521c53f14dc164d5a3920c9ca21a0e5f8e9613f43812a98af3e22af"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?colordiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c5f2ba805cda620b13a3505474a5ff2e3d119e1239cd6c3142a0c4c85dd6c29a"
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
