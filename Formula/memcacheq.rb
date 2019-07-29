class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://memcachedb.org/memcacheq/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  revision 3

  bottle do
    cellar :any
    sha256 "5b7bfd2266c6573684654167ae9d62d4e0c7132e3ee718e65203dde90a40f67d" => :mojave
    sha256 "cd1b3c570a517706bd3f96db3299dadfb5451d82130a9e781f522aafc0b4e924" => :high_sierra
    sha256 "f8799f00891f07bac41323e83d6c78cadc49c4a00946edfacece742f0730f7d6" => :sierra
    sha256 "babecb3a320c440e7aed14d3878cc9b65fd954263dc0707dbbeff7fa2aab7abe" => :el_capitan
  end

  depends_on "berkeley-db"
  depends_on "libevent"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make", "install"
  end
end
