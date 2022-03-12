class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.6.0.tar.gz"
  sha256 "2319efae884c8007df0e4e00435555a3e93a1f643f4a02dcb8d519203e443e4d"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199be2df4a9769cb74d0425aefabccd90e77b91781053b4b5ff2a1f0e53acc74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "632462cf5038853703765c3d690fcc929fb4c25cd04cff0016ed8acede1d5379"
    sha256 cellar: :any_skip_relocation, monterey:       "f905716187d766060f0ab39643ecca7015e65cde0eb4f444c2aab6c2b691ad39"
    sha256 cellar: :any_skip_relocation, big_sur:        "33bed6f2abc2935827f5b28c6f78a0e48b02e4ca060f501bd280f2d6ca8fd47d"
    sha256 cellar: :any_skip_relocation, catalina:       "4626eb1d6743b1b7bae8e0c8517fca7f3fff52b9a6d20594eb8de331aaf717b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2bb3aef234dd47c9cc376aa3cfc72522704cc9a01abe99d323034742c200d58"
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
