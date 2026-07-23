class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.15.0.tar.gz"
  sha256 "84f1bee2e92a9dadb41d95ecc64113e4d3def86224de774cd92003add8c4f570"
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
    sha256 arm64_tahoe:   "d34c48808eaf7628f2906e63416af678139fa2baeaf0a0bc414e456932b4ce81"
    sha256 arm64_sequoia: "0955c44ced79d4dc2226f82738597a60bfe64a71e4524cb3c9028bb879e6f10b"
    sha256 arm64_sonoma:  "1710fb560ca39365b8aac0d831a71db5768a5269bd5577083c00b1ef1235d474"
    sha256 sonoma:        "5d0e4814e65ff9a5d7d2b87f5b08cc76ae7082fac247ffcc75c37f5ba95f980a"
    sha256 arm64_linux:   "42ee3f5c692ced7d1e91dfa027828767efb63a41d2c971c099885d0fbef728f7"
    sha256 x86_64_linux:  "e915e5dae3e75127aa8147a9d7737ae23fe36c0e4bcbf8f0faf62c7d23ccf4ef"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dnstap",
                          "--with-libevent=#{formula_opt_prefix("libevent")}",
                          "--with-ssl=#{formula_opt_prefix("openssl@3")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end
