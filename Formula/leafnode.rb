class Leafnode < Formula
  desc "NNTP server for small sites"
  homepage "http://www.leafnode.org/"
  url "https://downloads.sourceforge.net/project/leafnode/leafnode/1.11.11/leafnode-1.11.11.tar.bz2"
  sha256 "3ec325216fb5ddcbca13746e3f4aab4b49be11616a321b25978ffd971747adc0"

  bottle :disable, "leafnode hardcodes the user at compile time with no override available."

  depends_on "pcre"

  def install
    (var/"spool/news/leafnode").mkpath
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--with-user=#{ENV["USER"]}", "--with-group=admin",
                          "--sysconfdir=#{etc}/leafnode", "--with-spooldir=#{var}/spool/news/leafnode"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leafnode-version")
  end
end
