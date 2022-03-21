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
    sha256 arm64_monterey: "d1d2eb0daa97ef096a12297bceb52e3823b5fa11f81dcdf1a4dec55d5e839714"
    sha256 arm64_big_sur:  "a2cf7fe155d08a4856b69f43d737a97cf8b79370f251fd2e309b58d23f905e87"
    sha256 monterey:       "9eb3c1b6572c0e1d243867047616e3d1572be6b1c907110dba746966205d8fd9"
    sha256 big_sur:        "39ae92ff6e92d44056fc11abef978d8b50d148c00503c0c455d446b96486c6cf"
    sha256 catalina:       "db8ece70220899f52d65a2d05537e4ef1a2d1b9d69960ce9d1d9a82c40c3276e"
    sha256 x86_64_linux:   "182d10079693debcb8702d21a4de0f54a2500e65d66dd8fd4d11d46ee5365e36"
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
