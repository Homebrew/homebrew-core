class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.4.0.tar.gz"
  sha256 "cfcd6fdd99344ca5a7ef7c2940c241bcef471fc3252ba3dcbd4c57e0638e8836"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_monterey: "a75d4f82d5adf8b493df619a1e2ff3bdf6e4efa370f6c363566db90d5ded9796"
    sha256 arm64_big_sur:  "b0d394e6bc604fb4e52a8c1730bf6c0665986f4afb95cd55ff29a5d743ba093e"
    sha256 monterey:       "824511e5a658720ad80b03f4c8b98eb3e3699c809f4b29e8886ead96e6025d79"
    sha256 big_sur:        "04ff576c47eb9dc4f7e20117eaf00700b7528cce6ff7de40185c26349bd46711"
    sha256 catalina:       "34c70f1bc9fb1cb18eb35236f8eb454f2c4626870e94a1f795b49d8d6df3cb48"
    sha256 x86_64_linux:   "ad813fa010bca886e76c7b6e4be20b7dba027993b1aa1c242a5206aa5a01a32b"
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
