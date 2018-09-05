class Liblockfile < Formula
  desc "Library providing functions to lock standard mailboxes"
  homepage "https://tracker.debian.org/pkg/liblockfile"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libl/liblockfile/liblockfile_1.14.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.14.orig.tar.gz"
  sha256 "ab40d4a3e8cbc204f7e87fea637a4e4ddf9a1149aaa0a723a4267febd0b1d060"

  bottle do
    sha256 "26b5675b6797bb7d652bedd7795bc8b141e4bc91f21fdd0e143f24cc2f76ef0d" => :mojave
    sha256 "49db28fa47ee7012be39fbb8ab03948c050a95525808aa27ad2f8521ff8fadc6" => :high_sierra
    sha256 "45b9f5fee9e1a0efa2439027cd72d5bc6fede1ec9391a46d0a9eb024e675b31c" => :sierra
    sha256 "f6ca20b97a651114986b485e950859e733a08384bd9ea08ef12eb8cd29f2e697" => :el_capitan
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
