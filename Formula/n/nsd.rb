class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.13.0.tar.gz"
  sha256 "83181b9cfee9495076f124926b28259e7f3911c4da80e17883c211c7e17cd04e"
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
    rebuild 1
    sha256 arm64_tahoe:   "0fee163d31c782df891c1437048a19763a3824a9f1617a2df0cad734a46c8291"
    sha256 arm64_sequoia: "2d074f30dd1cc0bf6c9d23040c937636d687ae902e05623a7b0f94ee356696e7"
    sha256 arm64_sonoma:  "15ee17b7f63e3018c47360ad079f9b0da806e8eb1411315947ed2c572e78ae9d"
    sha256 sonoma:        "dcc2cc4d9aaf6192b4f895db997156c97c2e2d3754173d10bbdfbbde1ad1732f"
    sha256 arm64_linux:   "5451d9855a5b62d075e8362e3228529da88c728518417678a98e738e885358de"
    sha256 x86_64_linux:  "6d12bcd4ef889302b2845723df72e6a7aea04a6691ecceba358763a43c4fe818"
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
