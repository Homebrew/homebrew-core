class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.15.4.tar.gz"
  sha256 "74a095fdb774a157c8aec9009e440fc3d2ba94c4372ae9ed86588c1719d1df2f"
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
    sha256 arm64_golden_gate: "4d410b14a62b1c2fc6bc25b56a504452f180dd654152dd6f6eb3ff7af94cef4c"
    sha256 arm64_tahoe:       "0a91c7eeea8f295cd683930b8c600bb14645396d4e4ec77c97cfcc8f299a002b"
    sha256 arm64_sequoia:     "984a5841febe3c6a7fb4484865a99e83cdfeb2abd5c2f7b6eb79d5f8d192e574"
    sha256 arm64_linux:       "25d424783a77fd569fcd27ec14c805d785780167b943886e34818be64c5e7868"
    sha256 x86_64_linux:      "8aa903c878808266a989a3230c0538d53733b2c5b37a8b01f57360f7461b0b4d"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@4"

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dnstap",
                          "--with-libevent=#{formula_opt_prefix("libevent")}",
                          "--with-ssl=#{formula_opt_prefix(openssl)}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"nsd", "-v"
  end
end
