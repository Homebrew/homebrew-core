class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.15.2.tar.gz"
  sha256 "bb4d57753c2cc2a641c92dab1021016d25fb4b972920bf4f0bbb8c40c1a9cce2"
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
    sha256 arm64_golden_gate: "9bd3f79f5a5642d9d2d6d7f75e4ec24191c927579957d17c6c0db0d36186230d"
    sha256 arm64_tahoe:       "b90e09cb3ee8c91f68c6a7418d581a9b164f5b6b9ea75d0f3ee41d4c70f88f37"
    sha256 arm64_sequoia:     "b0df831119f73793af2f6645a89d159d59b32448cc538fa1678c4271c316391a"
    sha256 arm64_sonoma:      "ee98c1b823179e83e76e239e344543935bab67ef098e5c75256a595e24ea036e"
    sha256 arm64_linux:       "6577adef35bda581d415dff9653aadfb04e2019b62e783d096e4cde8a23dbef5"
    sha256 x86_64_linux:      "a6efabd0178dda7c2bd8b30c12da6c8c49f24ba62aa8c0a3004288a3970055a5"
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
