class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.2.1.tar.gz"
  sha256 "d17c0ea3968cb0eb2be79f2f83eb299b7bfcc554b784007616eed6ece828871f"
  revision 1

  bottle do
    sha256 "15fe9de07dfa20af490932fcfa910401d77e46a8cf78fd1384ac20de5a4c36a6" => :mojave
    sha256 "4951265f0e3b760298eff2ad95985e2b8ad032b1c20c0518b94ada7c51c2cf0b" => :high_sierra
    sha256 "40bc10ebefa0738254133a168cdbe107dcddabcde42a6726a587bd1088dbacd7" => :sierra
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
