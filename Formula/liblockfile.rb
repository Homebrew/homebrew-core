class Liblockfile < Formula
  desc "Library providing functions to lock standard mailboxes"
  homepage "https://tracker.debian.org/pkg/liblockfile"
  url "https://deb.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.17.orig.tar.gz"
  sha256 "6e937f3650afab4aac198f348b89b1ca42edceb17fb6bb0918f642143ccfd15e"
  license "LGPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "d6425a72a9e1a04fd11c8793c31b1a4308ff974979b368439d62515ca7bd0c53"
    sha256                               arm64_monterey: "69933a745062ff9b8a41b7b3b7fec871efa9a99896b1ace2ccbf4cbafb2437f8"
    sha256                               arm64_big_sur:  "41a9d79f95f938532b4320a29c5f5bf3d7229a6df3f06413112d903e23589078"
    sha256                               ventura:        "5cd7c8a1982b414eb54a539e0866a31018da08e90449e9bf62211bcb40c5bb92"
    sha256                               monterey:       "fec045c7ef1d9e55d1aac480298de26dce1754a73cb86f2545be737bc528d84b"
    sha256                               big_sur:        "d13b1ce9f35885e1b05c9bd436e8edd0fc1b0dc7475219773655cb69bafcfbb3"
    sha256                               catalina:       "a923faddb180ea86f1038424613c3191bf5212fc44e25548284f5a0525e1b5e9"
    sha256                               mojave:         "143542d504f3f37df987e6f2c4291c2966cdb9ac15a6fd581155a4079758575e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b40e192cdbc7b9ecbc0e6ea36a893f5de7b4d26f5f8a094bec6ab31b3dc86b03"
  end

  def install
    # brew runs without root privileges (and the group is named "wheel" anyway)
    inreplace "Makefile.in", " -g root ", " "

    args = %W[
      --sysconfdir=#{etc}
      --mandir=#{man}
    ]
    args << "--with-mailgroup=staff" if OS.mac?

    system "./configure", *std_configure_args, *args
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
