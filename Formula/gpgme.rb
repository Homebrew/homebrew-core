class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  sha256 "b09de4197ac280b102080e09eaec6211d081efff1963bf7821cf8f4f9916099d"
  revision 1

  bottle do
    cellar :any
    sha256 "d909ec33dd574c20f2d5b24bb90588ee811a9c3c9cdc6bb11827b17af73458d2" => :el_capitan
    sha256 "f9976c4883fca4da0343dded00f144c4a2bfe5d814981e2bd42e000c31bbd181" => :yosemite
    sha256 "c304e956d73cca79685225902ec6989de8d9feb54d63b60e8999e290ea23c55a" => :mavericks
  end

  depends_on "gnupg2"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  conflicts_with "argp-standalone",
                 :because => "gpgme picks it up during compile & fails to build"

  fails_with :llvm do
    build 2334
  end

  def install
    # Check these inreplaces with each release.
    # At some point GnuPG will pull the trigger on moving to GPG2 by default.
    inreplace "tests/gpg/Makefile.in", "GPG = gpg", "GPG = gpg2"
    inreplace "src/gpgme-config.in", "@GPG@", "#{Formula["gnupg2"].opt_prefix}/bin/gpg2"
    inreplace "src/gpgme-config.in", "@GPGSM@", "#{Formula["gnupg2"].opt_prefix}/bin/gpgsm"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_equal "#{Formula["gnupg2"].opt_prefix}/bin/gpg2", shell_output("#{bin}/gpgme-config --get-gpg").strip
  end
end
