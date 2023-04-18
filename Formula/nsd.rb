class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.6.1.tar.gz"
  sha256 "3f60a3a13ec3f68e84bfa7e19daff663c82bcf1de96e4f53f2246525e773a27a"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_ventura:  "c01c6e84522213921bb7349801ab59abafaad2c6e08c3a11e160d6495271df3b"
    sha256 arm64_monterey: "19f8ea48f7178d4d5738c42352eec1d90591115754c822ff8c0b7177e48764db"
    sha256 arm64_big_sur:  "9d81b2669ec4b5b87980276a861e14f5d2883d43f241e73781db04562069f812"
    sha256 ventura:        "b2f76ac836618d067023dd1538210a1c7500a6bca9bf79c6dd4bf5086da45fdf"
    sha256 monterey:       "1b56916185f45888755a523b72e70d5cec659329cd2c89992b247c04207b82a2"
    sha256 big_sur:        "be385041c2b859bfe7160f7f9fd0a938bcb7aa66cb0d61c75297f118735b987b"
    sha256 catalina:       "30376e35ce106b7123f42cab2b6d7e0ab2f236332914377faeb4adbbb99a5b4a"
    sha256 x86_64_linux:   "9255fd433f419ccf2f059c802040906469ee6b36b24eabe9a2452199a0fb89c6"
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
