class Liblockfile < Formula
  desc "Library providing functions to lock standard mailboxes"
  homepage "https://tracker.debian.org/pkg/liblockfile"
  url "https://deb.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.16.orig.tar.gz"
  sha256 "cf6e3828ced3fcc7e5ed36b7dabdf9e0e3ba55a973dab8ed212fb86afc901c69"

  bottle do
    sha256 "c22eb6cb53066f5a9b16a60cf77a1b4980ad28b4f71f89a9e3c6bc5674c62b51" => :big_sur
    sha256 "4fd8e00fafc2190ddfba9a3de861ce86b5ce3d9942ccaed88833e0a78589ac37" => :arm64_big_sur
    sha256 "e5991a3eac0b5cd41f2850d73643607c33bb41b7014105f0ed80b75c5e7ef866" => :catalina
    sha256 "18663ff713cb46c514546f5a73026deb4e3df5b701b082b5cd68275581b05ba8" => :mojave
    sha256 "bc532693f97e4d14ac59974b80f5a31b121b5cc404efb2aacda1c1607f4bcf5b" => :high_sierra
  end

  def install
    # brew runs without root privileges (and the group is named "wheel" anyway)
    inreplace "Makefile.in", " -g root ", " "

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--with-mailgroup=staff",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dotlockfile", "-l", "locked"
    assert_predicate testpath/"locked", :exist?
    system bin/"dotlockfile", "-u", "locked"
    refute_predicate testpath/"locked", :exist?
  end
end
