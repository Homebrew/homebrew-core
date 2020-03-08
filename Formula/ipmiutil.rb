class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.5.tar.gz"
  sha256 "58ccdbd5755d7dd72478756715af09e9c73330dfad2b91dbf03d2ac504b301a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "02ae664c9007d6cea468932d1cc262b18c1bf549c7fb24d9d600437b58fccbae" => :catalina
    sha256 "83fc42e510001906bfd5d5b18a751f7499f522e36ebeb0eaff84f8bf158df747" => :mojave
    sha256 "89f8332794bc2c9a9bf15467c4ed1f9ca38ff5588687a569613322af8d185a48" => :high_sierra
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
