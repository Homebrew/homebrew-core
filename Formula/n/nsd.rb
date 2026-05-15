class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.14.2.tar.gz"
  sha256 "2bff57349841844d7560e76d7bd70b6bd6f4c462cdaa6d57b8e83d1e14dd22d6"
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
    sha256 arm64_tahoe:   "a4394782121330129516d8754a1afc60fcf65021a825f5bb7299b29e19471f46"
    sha256 arm64_sequoia: "542fa3457af566ece535603d02358889450e0f261ef4e95979066e3dbe3054d8"
    sha256 arm64_sonoma:  "c6d2bd7ca911de2af6ee07cda601e324d5864c19338fb1e1efa517ed055f9108"
    sha256 sonoma:        "84be842d16cf6d959917750f4519bae976aba6e3bae3ecd1f7ce865b0b212376"
    sha256 arm64_linux:   "24005bb47835c5d7df0fcf7cd12671f29c7b807f529b6822f958a64b71366e7f"
    sha256 x86_64_linux:  "ba65dde178817e42ce9436607b1cb60857dd8848c7ce00e94be9a0e80cd86dfd"
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
