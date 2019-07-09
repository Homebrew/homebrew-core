class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.2.1.tar.gz"
  sha256 "d17c0ea3968cb0eb2be79f2f83eb299b7bfcc554b784007616eed6ece828871f"

  bottle do
    sha256 "f63a856122e366a1413a5fbe580bfa40faa937696cee7a089c11241dad35a50b" => :mojave
    sha256 "491a88aae267376b31da83f39ef94ddf2cfb0c302f124a5671c6c5c06b740fcc" => :high_sierra
    sha256 "6aa3633bf07bad78e431f8856f8f94832196f92814b8cde319e0358ed82d8658" => :sierra
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
