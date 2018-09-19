class Cpmtools < Formula
  desc "Tools to access CP/M file systems"
  homepage "http://www.moria.de/~michael/cpmtools/"
  url "http://www.moria.de/~michael/cpmtools/files/cpmtools-2.20.tar.gz"
  sha256 "d8c7e78a9750994124f3aab6e461da8fa0021acc7dbad76eafbac8b0ed8279d3"
  revision 1

  bottle do
    sha256 "2a7281836c39574fe905ee34110756703298b774984d6796663c55d04dee7ea2" => :mojave
    sha256 "c4d8d3aa660ecea66f519582bd216b37e2f23b0c6714e70ad297c913fb297fe9" => :high_sierra
    sha256 "996f6ec337721c7d57a6c5b033ed4653b6a1f5f4998304c85e2a809c7e1cf0f0" => :sierra
    sha256 "e3fdab874e376cacefccd916de4c96bfaada75d1cc5af6f53e6bf9a625d3aa72" => :el_capitan
  end

  depends_on "libdsk"

  def install
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
    system "#{bin}/cpmcp", "-f", "ibm-3740", image, src, "0:foo"

    # check for the file in the cp/m directory
    assert_match "foo", shell_output("#{bin}/cpmls -f ibm-3740 #{image}")

    # copy the file back out of the image
    dest = testpath/"bar"
    system "#{bin}/cpmcp", "-f", "ibm-3740", image, "0:foo", dest
    assert_equal src.read, dest.read
  end
end
