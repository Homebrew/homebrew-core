class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://code.google.com/archive/p/memcacheq/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  revision 4

  bottle do
    cellar :any
    sha256 "214615ae51f807fb4a2990c337545be6376b74741467e91faaff57fb49008ea0" => :catalina
    sha256 "3a41379223936c7802a6df61454f70cb14fb6df6ae43e46d32fea87b1194c11b" => :mojave
    sha256 "8e519465f17eadf1db20439176d6d4c120572ca700e3c6d33706df73788f88f7" => :high_sierra
    sha256 "89f6b5b9085f13f38bacdff51c0082dc17ec992bc8c5366ebfd38542d91d5703" => :sierra
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
