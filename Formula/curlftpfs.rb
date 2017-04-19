class Curlftpfs < Formula
  desc "Filesystem for accessing FTP hosts based on FUSE and libcurl"
  homepage "https://curlftpfs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz"
  sha256 "4eb44739c7078ba0edde177bdd266c4cfb7c621075f47f64c85a06b12b3c6958"

  head ":pserver:anonymous:@curlftpfs.cvs.sourceforge.net:/cvsroot/curlftpfs", :using => :cvs

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :x11
  depends_on :osxfuse
  depends_on "glib"

  def install
    ENV.append "CPPFLAGS", "-D__off_t=off_t"
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
