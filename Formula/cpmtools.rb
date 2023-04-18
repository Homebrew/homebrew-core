class Cpmtools < Formula
  desc "Tools to access CP/M file systems"
  homepage "http://www.moria.de/~michael/cpmtools/"
  url "http://www.moria.de/~michael/cpmtools/files/cpmtools-2.23.tar.gz"
  sha256 "7839b19ac15ba554e1a1fc1dbe898f62cf2fd4db3dcdc126515facc6b929746f"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cpmtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2fbd054f0433e92761ef5fa76de830ac7bfeeb08525eede726f9d3d969e165df"
    sha256 arm64_monterey: "2324010d143ab9616a622b9d147b7aaf256feed91b05ee18226c8bfaa14f956a"
    sha256 arm64_big_sur:  "c3488e8102d67d29360061444be429adab96c2f6bff0d679af380846be8b9926"
    sha256 ventura:        "ee486061d9a3338f5b29ac3e999b18379685bf81503c52c4ce567eb0b1ecdd4d"
    sha256 monterey:       "01243a514e68e3d3dcc59a183a17e52c8101bd53ec3482692aa53b0790f90026"
    sha256 big_sur:        "feb6336a2eca5551ead4c111c3b3dc2f6d30b1b4f26b5b9845afe70ff4362165"
    sha256 catalina:       "21f01ac740cd1f784a1cb888ae1959df797deb5a06535c3ac9340feb04582339"
    sha256 x86_64_linux:   "c0808ec1572a5afa52930067fef0ea776df7de12aacd3357e014edfb9e80a3e6"
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
