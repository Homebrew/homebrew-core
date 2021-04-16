class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.6.tar.gz"
  sha256 "bee6c0cf5525acc41dade9ec9e29435299211b0de290059878f7e53249e75f18"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_big_sur: "5086e23660cc73659c74de90e45e37294b7a225059dfeb020015bd9e1310a4f8"
    sha256 big_sur:       "a86eb5d78001daa6a01bed25c6230703f5aacc7fdccca441e2752cd6be9b656f"
    sha256 catalina:      "d15af228defea21a4d66b72ba48548a91358f32f96cf3acfe9f8c6d5816ae049"
    sha256 mojave:        "1cdc33a7d9c500222beb60116709c8e6df85b555e65048982d7cf7aeedc6cf25"
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
