class Cpmtools < Formula
  desc "Tools to access CP/M file systems"
  homepage "http://www.moria.de/~michael/cpmtools/"
  url "http://www.moria.de/~michael/cpmtools/files/cpmtools-2.20.tar.gz"
  sha256 "d8c7e78a9750994124f3aab6e461da8fa0021acc7dbad76eafbac8b0ed8279d3"

  bottle do
    rebuild 1
    sha256 "b9074a4680a3fedd140d31d6597f286a8b49fd47cdedae36b45356ec2f60b18f" => :sierra
    sha256 "a659a233dc338bb7ec669185e22f0c19d03d9697bbe3521473cb7ff791fd010a" => :el_capitan
    sha256 "a127034e7197c21acbcc172b86d476988754ed56bb44b0d9b447f362017fc8bd" => :yosemite
    sha256 "b810122c220af6b36ab9316deec811adca68313d4371f8a0121239c40b94a015" => :mavericks
  end

  depends_on "libdsk" => :optional

  def install
    args = %W[--prefix=#{prefix}]
    args << "--with-libdsk" if build.with? "libdsk"

    system "./configure", *args

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
