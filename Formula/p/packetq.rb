class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.1.tar.gz"
  sha256 "a1b087335fcb018a5ded3d067d22ee906d24b6e932f018e959302be9b527c620"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772e29dc8f04711cdfeab1d1930db27433f609372ecec6f1a9ea8b3459431519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b37ea2ed6f049d5d85235a5713fb7e355ae63ec870847503424651f0b5b0ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c985f67ce185fe618952564a9eccf7927cb325be1ffec0b040f64b73061bff51"
    sha256 cellar: :any_skip_relocation, ventura:        "294b415eb4de3152240592d854f2b4c9a9212ae730deecf50926978533d91b6b"
    sha256 cellar: :any_skip_relocation, monterey:       "085d057f267c86b2bb471deccb2768100ce3c75b87111c673b25d7b173852291"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7866c5cecef9997ef4a37966479be14c80d79a914b5c5d2b99123eb910cb1e9"
    sha256 cellar: :any_skip_relocation, catalina:       "2f3b0e6dfcbee17aea1f379bb91eb51dee2805637447174ebdd7d6179bf5f23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7409419d5186439ecb79302d818df6331bcfe63bd3a245f0738205f4702c047c"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
