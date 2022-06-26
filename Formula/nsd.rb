class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.5.0.tar.gz"
  sha256 "5ae7a704ab92c8a49f3c8f3a29565ce194c51a721c29c75ea7d43c13372d79c5"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_monterey: "96e97280e0c7c33545246d86f0cbfd4a2973bb9674e99089941bada3a4dec66a"
    sha256 arm64_big_sur:  "bc2500d60d43987b25c38fa1502b23b7c760d39bda6be3e1a6792307fd9ef032"
    sha256 monterey:       "9244cd157082344665557cf6f722dae50d45425d7d159ec04a07421fe8af695e"
    sha256 big_sur:        "52eedf5b94fbd17ddd51d9540c634c5e6466da4f0b270227cadbbeadd4bf3ba5"
    sha256 catalina:       "f1a47cccfead8ee591b5071db62dab8d3751655194b0ee50cc8fd9918e5e3ab5"
    sha256 x86_64_linux:   "ab3ab023b66e7055515e473f98706932439068b2516180013f321296fa6c705b"
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
