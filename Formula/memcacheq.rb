class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "http://memcachedb.org/memcacheq"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  revision 2

  bottle do
    cellar :any
    sha256 "baa39077181e787e4001fe4b6c9f272e89ad08bf5641b333b1c887f4cc78b8e9" => :sierra
    sha256 "936659b1df64676cebe6876d4507b828761eb603eade7dbb5dfa40a6b8d6a49f" => :el_capitan
    sha256 "cd97f684ae8759b2406ba3d3a7ac70e5c642c160852e477625fb60e9170b7730" => :yosemite
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
