class Cpmtools < Formula
  desc "Tools to access CP/M file systems"
  homepage "http://www.moria.de/~michael/cpmtools/"
  url "http://www.moria.de/~michael/cpmtools/files/cpmtools-2.21.tar.gz"
  sha256 "a0032a17f9350ad1a2b80dea52c94c66cb2b49dfb38e402b5df22bdc2c5029d0"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cpmtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f11ea8bafd7bf4befef1903f1fc6635210a9372792fb80ab2bcec3ca30882015"
    sha256 arm64_big_sur:  "15e7282d0aaab6c0fdcba963da488dc134a3a91cdf386f975531ad6cb412eb4d"
    sha256 monterey:       "99d41c418cb5bd93df5611972aa2e34471121caac053e789758b5d4f52732c92"
    sha256 big_sur:        "72ac1f5c8c685e8a8e9e10ce3ba100883473f9578994752d0bcaab1bb987d27f"
    sha256 catalina:       "d685ce1a2f98dbab825d3b7c7584303214682f55fbd4222740a314ee9225d3e5"
    sha256 mojave:         "189b7777108827592800a7b8182357721a5314d2dae1559ec0d3663d5072870b"
  end

  depends_on "autoconf" => :build
  depends_on "libdsk"

  uses_from_macos "ncurses"

  def install
    # The ./configure script that comes with the 2.21 tarball is too old to work with Xcode 12
    system "autoconf", "--force"
    system "./configure", "--prefix=#{prefix}", "--with-libdsk"

    bin.mkpath
    man1.mkpath
    man5.mkpath

    system "make", "install"
  end

  test do
    # make a disk image
    image = testpath/"disk.cpm"
    system "#{bin}/mkfs.cpm", "-f", "ibm-3740", image

    # copy a file into the disk image
    src = testpath/"foo"
    src.write "a" * 128
    # Note that the "-T raw" is needed to make cpmtools work correctly when linked against libdsk:
    system "#{bin}/cpmcp", "-T", "raw", "-f", "ibm-3740", image, src, "0:foo"

    # check for the file in the cp/m directory
    assert_match "foo", shell_output("#{bin}/cpmls -T raw -f ibm-3740 #{image}")

    # copy the file back out of the image
    dest = testpath/"bar"
    system "#{bin}/cpmcp", "-T", "raw", "-f", "ibm-3740", image, "0:foo", dest
    assert_equal src.read, dest.read
  end
end
