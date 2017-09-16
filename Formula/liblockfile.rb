class Liblockfile < Formula
  desc "Library providing functions to lock standard mailboxes"
  homepage "https://tracker.debian.org/pkg/liblockfile"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libl/liblockfile/liblockfile_1.14.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.14.orig.tar.gz"
  sha256 "ab40d4a3e8cbc204f7e87fea637a4e4ddf9a1149aaa0a723a4267febd0b1d060"

  bottle do
    rebuild 2
    sha256 "ab9fc63a064b56bc38c6cfaed2f5dfe8f91b7c4b743a57167895d31ffc6c01d8" => :sierra
    sha256 "e4d6ff7643eebb7fd6726176db9938b0e68526d53909a5cf3a2dd6aff1c1a378" => :el_capitan
    sha256 "1db90af0082d415223b928d477b6abe2047d9bad9b2f07991ad4eee3e5c0cde6" => :yosemite
    sha256 "279009f21a530b2350ddc0321e649fe90ff443480522b078e0f082398d740f24" => :mavericks
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
    assert File.exist?("locked")
    system bin/"dotlockfile", "-u", "locked"
    assert !File.exist?("locked")
  end
end
