class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.6.tar.gz"
  sha256 "8814828c6c245140a5c867d8def8e88a72e90f67c79282008303de1c1d598e4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9c1f45ad31e61093e3ba002c3494d61e762666733c6f5d03c53e6860e9aaf14" => :catalina
    sha256 "e1862f31ab6cc95f37dda09ff7250e8b7f84750b075428e517779d37066f3c01" => :mojave
    sha256 "e6d9bf95fd37500104f94fb640f6ac71d922227190b05b4ccbbf70abc942612c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  conflicts_with "renameutils", :because => "both install `icmd` binaries"

  def install
    # Darwin does not exist only on PowerPC
    inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
    system "autoreconf", "-fiv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system "#{bin}/ipmiutil", "delloem", "help"
  end
end
