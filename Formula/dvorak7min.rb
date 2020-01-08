class Dvorak7min < Formula
  desc "Dvorak (simplified keyboard layout) typing tutor"
  homepage "https://web.archive.org/web/dvorak7min.sourcearchive.com/"
  url "https://deb.debian.org/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  version "1.6.1"
  sha256 "4cdef8e4c8c74c28dacd185d1062bfa752a58447772627aded9ac0c87a3b8797"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8f692d9254375715d1f85af32ce5b7487802597818f2bb969b3cac109d3012a" => :catalina
    sha256 "2657090fcb79b647e9c805780eb2a90d6a875aee6aebeb2dc0eebbdd3ace3ed1" => :mojave
    sha256 "0cfad9ea53f984ebc81c87fe2bd7fd8f3bad6c8c0032085de36eb499b041b5b0" => :high_sierra
    sha256 "052c259da37d2e9576fdf1809ce526dd54cedd362bbe747f02fa088e6568983b" => :sierra
    sha256 "d4bf1a053028f0712193e33911c2af3fb4f0a71b37480969b5c03b798d4930ae" => :el_capitan
    sha256 "42cad6dbf3f41053e5ba7509657dcf7e02c6211412efb246eaaa9de853a09d35" => :yosemite
    sha256 "096700b282a6130a3948e3fc8535584cea129865aaaef81f5d89fac3a39d61c1" => :mavericks
  end

  def install
    # Remove pre-built ELF binary first
    system "make", "clean"
    system "make"
    system "make", "INSTALL=#{bin}", "install"
  end
end
