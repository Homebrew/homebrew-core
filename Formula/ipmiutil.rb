class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-2.9.5.tar.gz"
  sha256 "eb00f0582ee75e1f8d371e398d546ddd7639595b9a0a1f27a84cc6ecb038dbe6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "57b2a63f6564de22edd0e314f188a6a6f850298954e7b31a9bcae60c497f9c58" => :catalina
    sha256 "83d9f7ccbc8950dcc3a653dc3f35ed742129d1eaaf547585bbc76b8d195eda64" => :mojave
    sha256 "a0119f2e672668e9792c2d6bd6cfedc4797612e4b2b98fa691b74f936b4198ee" => :high_sierra
    sha256 "8e136064d7075e847c87bc7f7e1e9bc583259f51205dd69ddafb0708fdff3f66" => :sierra
  end

  depends_on "openssl" # no OpenSSL 1.1 support

  conflicts_with "renameutils", :because => "both install `icmd` binaries"

  # Ensure ipmiutil does not try to link against (disabled) OpenSSL's MD2
  # support. Patch submitted upstream in
  # https://sourceforge.net/p/ipmiutil/mailman/message/33373858/
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
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

__END__
diff -u ./configure.bak ./configure
--- ./configure.bak       2015-02-04 22:15:07.000000000 +0100
+++ ./configure   2015-02-04 22:16:18.000000000 +0100
@@ -20739,7 +20739,7 @@
            echo "Detected HP-UX"
            os=hpux
            MD2_CFLAGS="-DSKIP_MD2"
-           OS_CFLAGS="-DHPUX"
+           OS_CFLAGS="-DHPUX $MD2_CFLAGS"
            OS_LFLAGS=""
            OS_DRIVERS="ipmimv.c"
            drivers="open"
@@ -20748,7 +20748,7 @@
            echo "Detected MacOSX"
            os=macos
            MD2_CFLAGS="-DSKIP_MD2"
-           OS_CFLAGS="-DMACOS"
+           OS_CFLAGS="-DMACOS $MD2_CFLAGS"
            OS_LFLAGS=""
           OS_DRIVERS="ipmimv.c ipmidir.c"
           drivers="open direct"
