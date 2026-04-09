class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.3.tar.gz"
  sha256 "faa9a3700bf6010347fbfa595b7777d32059a77abbb027f6e070b419369d7718"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f2ffe806704b6ccf4a3b36ed2a03229aec5ab347638c02bc048b1869c269b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0616b69581ac77fc31dc4a4d4a3d9258421ee38538997e38eca9a66a62d10339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "175c53c989f9b926e7ddcf382517cec08f015ab1635938659ef8045f69e37e0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26f2629870ea59d9bc6673411af50187b30cd4cee701fadf1557e6c949b43749"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d955362f371fe590e3a44a3fb66eef99bf88782410e6c7ee4c3b9c3b62c5d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5afff996605124f10306b5a479c3b619b35f1719b262a939f4a02d3528a29800"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
