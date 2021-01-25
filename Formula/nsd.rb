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
    sha256 "89235887c73372327a0f4c372d5b93e5fbccfeb6bde079d02d4c932b1982a020" => :big_sur
    sha256 "af4902f97a90e7b5a011268389edb36d95b0df049d8f0faaf87cb6966abca30c" => :arm64_big_sur
    sha256 "b21b9f1ad17d10473d8acc41b37d75add960de933ae5c7569eec2a1d2a9be79c" => :catalina
    sha256 "aa51669ef28ff75d2eb3fb4dd9dc02dc905b0bb96c78a6740c54296e0b4626ed" => :mojave
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
