class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.0.tar.gz"
  sha256 "6c275d1a0139ed191973593895ac0b313866a4bfb832e969eec0650d1c03f82f"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b18d16fd291fbcc6e7b89e94d1beb38c28c55d9058aecc5a47762e544451842"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "602151d75bfa0684f3aa52b957b6e63a51757741e8a67647abbc5a500e9bf838"
    sha256 cellar: :any_skip_relocation, monterey:       "fd2d3343a6a827431b84d4ca63a61b025cbed8c8bacfe89f82ed2af66d0290ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2a675266e49a77bd5ccc5b354506c0fe41bcaca3254126363ad9f3df1b5f8a6"
    sha256 cellar: :any_skip_relocation, catalina:       "a7ab7f52ebef6e9ef147be842e3cc1ca4e25a4a456850072e1b33841391451b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87eac1791759336c6189f9b4d055ddbab4674523848b1aa54511e9f5dcc9f5ab"
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
