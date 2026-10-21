class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.15.3.tar.gz"
  sha256 "6cd323354ebdf8c6a1eb5a14ecce25c69534013b70e7b0197d915cd581ab530c"
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
    sha256 arm64_golden_gate: "adb43e5b25782fe86664b9f50c4100aa128547ea8f9b30551e1168944ecba031"
    sha256 arm64_tahoe:       "5766f00bfe5307e987cb1d613039bcbbf950880e385a9bf3080e91254cea3c66"
    sha256 arm64_sequoia:     "cd7170e90413a2f3ecfa7c620ffbe6c70ecdf60172206ddd3deaef435f0c4699"
    sha256 arm64_linux:       "40356305a3961845bc60601f496621cc5c34256ee7e8b0b2c2a8d65c9cf6946d"
    sha256 x86_64_linux:      "973eb0a6cd9f2b29972cbdc9d6dfe3ed1e97e4dad9f6196764b0bfca6a5f2322"
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
