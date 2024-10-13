class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.10.1.tar.gz"
  sha256 "c0190f923f0095995f2e6331dacd92c6e1f4d578b880d61690602b43a5acfd84"
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
    sha256 arm64_sequoia:  "7ae36d4553f3fc44b8e502fccf7029a594a6764f03d5881f7e5512641a7d565b"
    sha256 arm64_sonoma:   "3460116714f6081ea1b1ff74aa6d69af3dcd90c5afdebe393aae19af8d052224"
    sha256 arm64_ventura:  "6b051779b60b8d878dd094338c58fed35c7a54874297f3039a1c1e196b95e363"
    sha256 arm64_monterey: "7a814959891aea2529609ab8e88f382956669f2ba69d194c7c4a57bf9085454f"
    sha256 sonoma:         "cd6d2ed468d4183bcf79002d0f533f01380ba0eea2c606200b69bc4f56104e27"
    sha256 ventura:        "93bbc4a2bd5b2f7cb8e764c011e262785a06398d5c7a362fe9955422d3c5c4ba"
    sha256 monterey:       "2a607b26919ffce37e867e790d24bc6920fd6a6a2cb19393dab5f1f64ff0d608"
    sha256 x86_64_linux:   "202a6511ed192c3cb3409f9ba7c50b8bfcb3dcb887037fe67b7317e34eb1f765"
  end

  depends_on "libevent"
  depends_on "openssl@3"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end
