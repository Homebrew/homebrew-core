class Nylon < Formula
  desc "Proxy server"
  homepage "https://github.com/smeinecke/nylon"
  url "https://monkey.org/~marius/nylon/nylon-1.21.tar.gz"
  sha256 "34c132b005c025c1a5079aae9210855c80f50dc51dde719298e1113ad73408a4"
  revision 2

  bottle do
    sha256 "81bb68359ab8969a66c60b467890e9be12a1d003844d7a76f85ca2b4c3c47ea9" => :mojave
    sha256 "ad3ce3dde251f725f9659926ff529ca23e3e052a084221052bb6f4f1bf715abd" => :high_sierra
    sha256 "aea3b5d69a3a6b1046597e7d5b26ff3b2084e7bd47c3f2f44933d2ff351da1d2" => :sierra
    sha256 "e11dbfcb33533384db298fe84ed065f613db0c3503cd211b4404c586bfd19218" => :el_capitan
    sha256 "6bf95ff668064396bae3a677320425eb5ec66e820d2099dff37ed109c2f2dca6" => :yosemite
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libevent=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    assert_equal "nylon: nylon version #{version}",
      shell_output("#{bin}/nylon -V 2>&1").chomp
  end
end
