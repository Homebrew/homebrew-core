class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.7.0.tar.gz"
  sha256 "8faca44e299ad2915fa000887ab1632631ea68709c62ce35f110bfe721ecf214"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_ventura:  "6d22a9fce1d22d300237bba1290253080ed5fc77c56a302eb16a15610bb7e47b"
    sha256 arm64_monterey: "e7fdc73bb33247726aecb063deefb271b4ce893bedfde26a35a196d0c5d6861a"
    sha256 arm64_big_sur:  "c8ef7c1fd1087a250abe89b82b2cb6b8d82ce99b86b60873bd3983e4e2aa8418"
    sha256 ventura:        "420ba1cd37bc74fa90d3344f965e4b3d12f9e8adeb45fe8c5fc47558964698c8"
    sha256 monterey:       "a5437cd05b4da7209c380860b508a9fe896f483df0519b548cf7fcb9de32a486"
    sha256 big_sur:        "5dc0c2ebbbad72fc0febc44cf09bdf5b4b9def56668d8df7568146fbaf706535"
    sha256 x86_64_linux:   "2415b677f4f0449e456c24e882256354a63c509a2e3f4df708250f740083fd1a"
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
