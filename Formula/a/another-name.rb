class AnotherName < Formula
  desc "Filesystem for accessing FTP hosts based on FUSE and libcurl"
  homepage "https://curlftpfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz"
  sha256 "4eb44739c7078ba0edde177bdd266c4cfb7c621075f47f64c85a06b12b3c6958"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "glib"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    ENV.append "CPPFLAGS", "-D__off_t=off_t"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
