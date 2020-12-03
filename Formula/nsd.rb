class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.4.tar.gz"
  sha256 "3be834a97151a7ba8185e46bc37ff12c2f25f399755ae8a2d0e3711801528b50"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[-_.]\d+)+).REL$/i)
  end

  bottle do
    sha256 "b3eeb6e4a4145b3384982aa2330690834373f547235a659404eefd974163b199" => :big_sur
    sha256 "d2d0731a5a4a03fff114250debcc1ff5fa6fe15faf77351afda9a2ccc6cdfbd0" => :catalina
    sha256 "1f0661c9656ab0d0821a9eeb5b990c9eb6a088654e5406318577084296ab8119" => :mojave
    sha256 "189a5b486bbfdcc0571e89f67d5f4f11474ce1fe2fb9e5ca720ced3662aba054" => :high_sierra
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
