class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.8.0.tar.gz"
  sha256 "d89be327a505a86af0a76c3e41529998b75ebee10bd86e0c0b7f907666f9c741"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bffbf8b039c3e2d1364a5114ec3e1e550a51eaa19c46604bdf5dd1126bc67ef6"
    sha256 cellar: :any, arm64_tahoe:       "9e7c6165060837d81be19767afbb9f78ca3648152684e7ecfaa8b9fc4bfc8ecd"
    sha256 cellar: :any, arm64_sequoia:     "93f379e6c0b6f00334b243d08bab26c4f5f43bb5a04fe16254a21948ba4b3050"
    sha256 cellar: :any, arm64_linux:       "451a60c57176afac58bac1f6ce3c5441e63a4224818a566823bce56a37fdc209"
    sha256 cellar: :any, x86_64_linux:      "f7d2e36a2c80912d2c6d416180e2183f8c6193985ae6eb2e52c29c90cc6d6f6b"
  end

  depends_on "pkgconf" => :build
  depends_on "dnswire"
  depends_on "libmaxminddb"
  depends_on "protobuf-c"
  depends_on "tinyframe"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
