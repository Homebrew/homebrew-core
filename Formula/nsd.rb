class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.8.tar.gz"
  sha256 "11897e25f72f5a98f9202bd5378c936886d54376051a614d3688e451e9cb99e1"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_monterey: "e18a0e3540af4de478b1c9178bf9c779943a3872315ed940ab06eb8e82fbe48c"
    sha256 arm64_big_sur:  "40eccbf26b9b22bf1ae9c12aa29cb6d64025d4f8b0a33d07f80a10342e3344ad"
    sha256 monterey:       "b7e6759930a565a9d66d0b6ffaa7adb9128249cfc494d29b7a8415c38f8fea78"
    sha256 big_sur:        "df218d39f9ad39cc5f02262a67dd0df660d4bfd7cc3647ebe9688f33de1d5431"
    sha256 catalina:       "5f36529e2b232c82c6f26ce53a68bc3b5f4256061ba6788cc318d6b888d49a4f"
    sha256 mojave:         "bbf84514d5ffb755af3fb96fecedbc69982ddc61874da7acab829f7ad44e3fca"
    sha256 x86_64_linux:   "3e856341d7f6fe3377af54a78870cdbe1dce23ee672a6d3e05d49c61e32dabcc"
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
