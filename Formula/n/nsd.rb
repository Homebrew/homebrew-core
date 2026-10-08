class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.15.2.tar.gz"
  sha256 "bb4d57753c2cc2a641c92dab1021016d25fb4b972920bf4f0bbb8c40c1a9cce2"
  license "BSD-3-Clause"
  revision 1

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
    sha256 arm64_golden_gate: "6f6faf2d1c1002104e3231cb54d659bdc99808dae8c9117afa68e484e0a100a2"
    sha256 arm64_tahoe:       "72ab9f58ab5b1c9219b9e8c523097ba4047d4b20a5872fe863ff04967e79dcde"
    sha256 arm64_sequoia:     "5b1c7b1d925c4cc14f085bcf7816be3da971d3996d073983c1d72375d0d8fd2c"
    sha256 arm64_linux:       "97ea8dbbbb97727f412f160932784f62fe23cbfe312b159c836eb479f11b6945"
    sha256 x86_64_linux:      "e14a1191f0d3bf9fade7935ad5b1733ea54aebf174e6ee2ee5ddcd6ed03632dd"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@4"

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dnstap",
                          "--with-libevent=#{formula_opt_prefix("libevent")}",
                          "--with-ssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end
