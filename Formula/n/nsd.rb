class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.9.1.tar.gz"
  sha256 "a6c23a53ee8111fa71e77b7565d1b8f486ea695770816585fbddf14e4367e6df"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)

    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "9958d6f7c15565c989ce8741993e4184b8b2825078de9938126d69d8472f4373"
    sha256 arm64_ventura:  "cf40fce0970035dde8ead67267160852581ab08813bd0684d8c75c2d9e873304"
    sha256 arm64_monterey: "d294f6e27ebaa7f10bb9f2fe69206323926902c97ffa56d8bd8dfbc1889ab67e"
    sha256 sonoma:         "0aef0cdb96f73d5b621a9bf3cecacc1d0aa588817ac746679b4c13559ac82f7c"
    sha256 ventura:        "a9220df020d868517f711f0ff79a5a70b7db2dc13cdeb72e8677f62142578e33"
    sha256 monterey:       "9ab5c972729706233da0d5789d3db92293490046287c3d8ea1f17583728fef98"
    sha256 x86_64_linux:   "001bbc937757a13e8dccf9732a129722f7d17952c1889c2da1c112679ff3bab0"
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
    system sbin/"nsd", "-v"
  end
end
