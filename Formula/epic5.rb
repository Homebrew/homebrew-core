class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.0.1.tar.xz"
  sha256 "55260fc832c76f7a4975bde2bd0d0805fd8012fc8908ac94ec8c6de24a1be7aa"
  head "http://git.epicsol.org/epic5.git"

  bottle do
    sha256 "9aeed705e50bf7f3459d0a8d0dd086c8c2c86d8b6028c22a002d60e3a5183183" => :sierra
    sha256 "0040885911e6bbab3b2b7b1c29e99e31363e6f24ff83d982afb54a1d11623715" => :el_capitan
    sha256 "8617a71ad3aead7226e7a71f90f5a834341031b6195c862d64757a662cb7e8a1" => :yosemite
    sha256 "0f17c628454c763deb0d5e20d488b0ef427ec6d5041a7f7223a0eaa9fa601e7c" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
