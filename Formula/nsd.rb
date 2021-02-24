class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.5.tar.gz"
  sha256 "7da2b43e30b3d7f307722c608f719bfb169f0d985c764a34fa0669dc33484472"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[-_.]\d+)+).REL$/i)
  end

  bottle do
    sha256 arm64_big_sur: "8747dcfda2d586a4884351199cfc427aefacd3f17b9a95ddd92cb78296d5ac6e"
    sha256 big_sur:       "3f7f34e3f1ad35123efbc45e0f5453d18d931a54b32357c3461b015fc76474dd"
    sha256 catalina:      "c7bf16604821f3604d9308c289f4c408f0711cbec714f0f62aa6ea6b0485bd96"
    sha256 mojave:        "056cb5f3bd860c59493827c7336e320b931353dae9fe0650113f1ca497f9c32e"
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
