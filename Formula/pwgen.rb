class Pwgen < Formula
  desc "Password generator"
  homepage "http://pwgen.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pwgen/pwgen/2.07/pwgen-2.07.tar.gz"
  sha256 "eb74593f58296c21c71cd07933e070492e9222b79cedf81d1a02ce09c0e11556"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2708a7cad30519c22cb27911af89ece70ffa11d50fe9a91ae54c181b8598b6e" => :sierra
    sha256 "2e1168a759cb56294d7230d00373943bec205cee6095e33259ea37b439534642" => :el_capitan
    sha256 "c51fbe547101e64291866313443a5a50c7744055ed580e6f659fa0fdccd98067" => :yosemite
    sha256 "e4c38fac94b1bd13e9082cc9b512798927495ec9a92083381c99bd3b978d3d08" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/pwgen", "--secure", "20", "10"
  end
end
