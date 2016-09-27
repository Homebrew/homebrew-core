class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "http://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.3.0.tar.gz"
  sha256 "f344b9af622980e3689d3bc7866a913c6794ff5c22b09fa92e2b684309aba958"

  head "https://github.com/rwos/gti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ba1a8b400ade1296a9706a25d43d86bf37b2ab81047051b287dae3bf0021654" => :sierra
    sha256 "b253c79ace49639af50fbe80ef39b584d2e4ebc26bf4e7069801790dee5fe000" => :el_capitan
    sha256 "b5ec12785d74eca21caa9eaebb089f6d666ab4a4e5516f4c007bbb2f40d55e36" => :yosemite
    sha256 "ec53667c16637cad636131f5b34885a517814531991160cf696e7713ebe2a36b" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
