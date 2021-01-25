class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.7.tar.gz"
  sha256 "911fd6f8b33651b98863d57e678d2fc593bc43fcd2a21f5dc7d5db8f92128a9a"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3cb5c77d4305480078d8a4cfbab0118a5e8304a13eff06ac95ba9575f9ec06d1" => :big_sur
    sha256 "d2870b00ddad6b22295009482c51e7d699dd8d0d0c32fafe3a5699c6b30e3f45" => :arm64_big_sur
    sha256 "ad8fc089b714a2286884168e7ce78e4cfb9a2c045e7daf9ee77eae3524bb0f8f" => :catalina
    sha256 "af41d4e3592cea0b3151276cff34bfabc810b47af165dc16436e8af30877e52e" => :mojave
    sha256 "502b711bfa0411d970ac6fc5dabd65e04a0a80b0bf0adead2fa1e965f2079050" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  conflicts_with "renameutils", because: "both install `icmd` binaries"

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
