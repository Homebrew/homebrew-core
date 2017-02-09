class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "http://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.0.1.tar.gz"
  sha256 "762cbd40cc17f81512ca94a622bc01bd122c92215880407e906356c0b3da309d"

  bottle do
    cellar :any
    sha256 "896eea4929dcd86ede955f0657424d1bb40e9a08e1aeb4d42658f4a8c00a9095" => :sierra
    sha256 "25f46961b538e12edffb311b07cd90af6ad7e4dc323431b6e512375f243e9f21" => :el_capitan
    sha256 "9fe09553dea21a6ea088bf0d571400da32b9826ab07263e6f9f618c34c2980b4" => :yosemite
    sha256 "b1372295d77f7d211372bb496c856778369397fea35db58aba7262ad157e191e" => :mavericks
    sha256 "debbe1e403702b0ee6178ca9674f7c05c4db8f1e68256152eb1c91482eaeda2d" => :mountain_lion
  end

  depends_on "openssl"

  conflicts_with "renameutils", :because => "both install `icmd` binaries"

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
