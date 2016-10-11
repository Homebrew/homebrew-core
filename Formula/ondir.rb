class Ondir < Formula
  desc "Automatically execute scripts as you traverse directories"
  homepage "http://swapoff.org/ondir.html"
  head "https://github.com/alecthomas/ondir.git"
  url "http://swapoff.org/files/ondir/ondir-0.2.3.tar.gz"
  sha256 "504a677e5b7c47c907f478d00f52c8ea629f2bf0d9134ac2a3bf0bbe64157ba3"

  bottle do
    cellar :any_skip_relocation
    sha256 "90e85060a76337368083c889379b71cda5994ab163b73337050819472f41800c" => :sierra
    sha256 "8d841a2a8b98a512265dc05deb3ea74e7458a4d5412da786f595c31420b7fadd" => :el_capitan
    sha256 "3d7b419d963bcd2be6d04cb3f666c8c58866f9556251f6efcb2f0b6abcad5902" => :yosemite
    sha256 "a994efec34c5c9edd1b014959b3fe1a1a95c1d9ece14c5d7d7c51c2b421c7a11" => :mavericks
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
