class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.8.0.tar.gz"
  sha256 "820da4e384721915f4bcaf7f2bed98519da563c6e4c130c742c724760ec02a0a"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b471a5015e4b27bea0f0f05ac55534dbebd56b6390f169751a963df06d756960"
    sha256 arm64_ventura:  "1d9db44a381d856e39862fe8e521a8191eb2347a8d0eda2f13fec17b5c70ddfa"
    sha256 arm64_monterey: "64959feba62df07130bfa5ac95c77fbfa2199b017374587bbe8bd876f54c9028"
    sha256 sonoma:         "92e7032e9c943d2212e9b0ec7b16fe0c46465b481b4277bf742caa58d08b32a1"
    sha256 ventura:        "269c979574d6182c0c58e87ce28d8d19999efcdb6a498728c79aad322b0e4510"
    sha256 monterey:       "64569a1e65533a18fb72ed2cc8e75c9f5733976c4753a83f669428cccfc0bfa5"
    sha256 x86_64_linux:   "1a5be43de15d68aa8aadf387dc4f6b5584911346b02fc982232a3f611f52f7f7"
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
