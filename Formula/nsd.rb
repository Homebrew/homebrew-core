class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.6.0.tar.gz"
  sha256 "09062d9b83dfcdde4e4e53ec3615496d68c2821d8381d0d464ebea31a5975c81"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_monterey: "eb1748e23dbdd462828ae89da55c35b2aa05b5c3dd587da3a09c679f1e528d1a"
    sha256 arm64_big_sur:  "a34549c04aad76d4436d3ea96bfeb40382497002b5dd294bfdec9592b149f64e"
    sha256 monterey:       "9a53af7722e58e842810eb8818459f435253656e5d0785f01bc23eb6e4957c92"
    sha256 big_sur:        "cc40feb2a8f0fadd9e0efaebb48aa0ae1c46eaa2629be8721fcdcceb0b6b841c"
    sha256 catalina:       "3b5674fa6a5149317eb3e684d703f9b859f43895ab7777e3e2a36b397c9c6643"
    sha256 x86_64_linux:   "25eb58224d17ae889a1b8c9f02c048e48ab1338f6f9c09271ee2a89b81873118"
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
