class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.14.3.tar.gz"
  sha256 "9629ad64d9c1b019bbe22296d5148d7ae65f588ce265a6424750740f052bb12b"
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
    sha256 arm64_tahoe:   "c1ea6ebd853b5390aa5208bef1a38c922a117e8b7492dabf70572674fd38814d"
    sha256 arm64_sequoia: "4e22c406fd68f0c866dfe9667d03df7e67c3beb387e4ab728915c0654e132cf9"
    sha256 arm64_sonoma:  "7eea1eabf8bb65d32c43d4c53ad037978acb2f095e5675abc3b7fffc17b46222"
    sha256 sonoma:        "262faf89c8574ee835e4b818174b0b9ddeef69fc219a7bb6ce24e7eed4313c87"
    sha256 arm64_linux:   "942e76e6d9e5e313ebf82542ee75c5360b9506eb2d58858782fdac1b15fa28ed"
    sha256 x86_64_linux:  "f85789504e9954ea21406d3d850acae3e652e254145917f95561bf4df5b23540"
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
