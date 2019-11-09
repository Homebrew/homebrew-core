class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.4.tar.gz"
  sha256 "9938ca13f55d2be157081d49c8c6392391b057c9818e02d5ef231a62e54a8a65"

  bottle do
    cellar :any
    rebuild 1
    sha256 "57b2a63f6564de22edd0e314f188a6a6f850298954e7b31a9bcae60c497f9c58" => :catalina
    sha256 "83d9f7ccbc8950dcc3a653dc3f35ed742129d1eaaf547585bbc76b8d195eda64" => :mojave
    sha256 "a0119f2e672668e9792c2d6bd6cfedc4797612e4b2b98fa691b74f936b4198ee" => :high_sierra
    sha256 "8e136064d7075e847c87bc7f7e1e9bc583259f51205dd69ddafb0708fdff3f66" => :sierra
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
