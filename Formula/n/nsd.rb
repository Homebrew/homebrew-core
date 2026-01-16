class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.14.0.tar.gz"
  sha256 "5d60e344002a9cc609ab71951a3cdb906314999e42f2a269044f27259ac2f12e"
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
    sha256 arm64_tahoe:   "9c2211fe644e1c586e3e496c0689cd424c7388798027e0a9af946023fcf3420c"
    sha256 arm64_sequoia: "0c7e00c316562ee8fe6db5dad154b5b55e3b8c203306341ae936ece6a05a7898"
    sha256 arm64_sonoma:  "b0c074fe848b77f9ef9fefb9a89749f1f761714547cf6db179fa01848da0fbf8"
    sha256 sonoma:        "7dbd92eef76fb9c67ed7297664671253dc6afa971e8ab0e441ae3efa23564eae"
    sha256 arm64_linux:   "120888feeb73940152c9bd502e9b07290e6f2c3498e7937277611db3550df6fe"
    sha256 x86_64_linux:  "6345078e7a36cfeb4d8eb4a00af70584450deee2403e90d9926fcde5cb9feb6a"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dnstap",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end
