class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.2.tar.gz"
  sha256 "5b5cee2f80ed451f19e02dee620c71a98a781bd72a55810e0acc925fecaa8329"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[-_.]\d+)+).REL$/i)
  end

  bottle do
    sha256 "c466ecf5c21b6e2454b65df532abc3c70de837eb383511024d723914ae325d8e" => :catalina
    sha256 "0072f454fa6565e04f625046b56ed790b4053cd691aab71cadc664503f0bcacd" => :mojave
    sha256 "cb8acf39097774f28de4cf2e9f76c7c4f17d90c6de9f38917f106cca5da7ab29" => :high_sierra
  end

  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
