class ChinadnsC < Formula
  desc "Port of ChinaDNS to C: fix irregularities with DNS in China"
  homepage "https://github.com/shadowsocks/ChinaDNS"
  url "https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/chinadns-1.3.2.tar.gz"
  sha256 "abfd433e98ac0f31b8a4bd725d369795181b0b6e8d1b29142f1bb3b73bbc7230"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962e197fda53c506ca1a8a11ab883c4e7b154a12ea747219b4add76e8fc2cc0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b400b323f97ff6d0570ed5b2ccffc2325516dea3c12d6ee18c5903ee2d607f3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a5921a1eb32cce03417035e20ed9fc3c52569bbe3cc963f4a5d8dacd8a61bd4"
    sha256 cellar: :any_skip_relocation, ventura:        "25c8e721baf2e9622339fd932f96af2e331aceafe6188f196536455cf4e77f20"
    sha256 cellar: :any_skip_relocation, monterey:       "3269038188274afa37cfbc4155f9aac9d63c5e47ac0e1cae9b10eb3e6eab63b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d15cde6788156aa67dffd280752d52f5aac1ef1e8f56c8e5864ce05b9c81647a"
    sha256 cellar: :any_skip_relocation, catalina:       "0c4820f0e5a12421b0e64c3cb993608560817a446b8747e7119838cb271b9044"
    sha256 cellar: :any_skip_relocation, mojave:         "61ccebe523d9e2417385c911beca6a01ee7d2810f1a665fca9a4f6a0e7b81623"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5b0b51abe8a40dee4b1296e81da179aff05ba42befc869e06e081d7e6fc4e726"
    sha256 cellar: :any_skip_relocation, sierra:         "fa51351f3cdfb63fa672d2011c08ac8a1f9a260bcfaacb13e4657f39e721b96f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "a620bce8421a9773233c51886c6845995569a1fda80e252efa86f6271c1d274c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7158e876b817917183a78e96e891dcd9ff9cefe333d1b139c73f9209fd585b0"
  end

  head do
    url "https://github.com/shadowsocks/ChinaDNS.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/chinadns", "-h"
  end
end
