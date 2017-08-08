class Pwgen < Formula
  desc "Password generator"
  homepage "https://pwgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pwgen/pwgen/2.08/pwgen-2.08.tar.gz"
  sha256 "dab03dd30ad5a58e578c5581241a6e87e184a18eb2c3b2e0fffa8a9cf105c97b"

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
