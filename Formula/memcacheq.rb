class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "http://memcachedb.org/memcacheq"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"

  bottle do
    cellar :any
    sha256 "5b42b846a028b765da1ecfd3337b5b2fb12582d1b5f4584258f9896257b3eaaf" => :sierra
    sha256 "27b972d2f3c9d63ce7769dd964f575bfd0cb8f6136a666c713d5c66390f23ff3" => :el_capitan
    sha256 "91d6ebd845b87bfe94cfa32f62220c8f4bd748c7c4daa61f318cc6835eb52973" => :yosemite
    sha256 "73325fc64a4c34b0bbfacd59e30bd1f07e8052e851f9226e7a71d3c2061e173e" => :mavericks
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
