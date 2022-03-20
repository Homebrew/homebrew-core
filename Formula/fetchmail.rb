class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.29.tar.xz"
  sha256 "397df984082abae51edec6831700d68636f0e117cfaffcbdd3eed66d04b97321"
  license all_of: [
    "LGPL-2.1-or-later",
    "ISC",
    "BSD-3-Clause",
    :public_domain,
    "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" },
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/branch_\d+(?:\.\d+)*?/fetchmail[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "1fe37b81188d8a5afe05c17ebdd492e1a0204168aabf91c0b913fd887aab41d3"
    sha256 cellar: :any, arm64_big_sur:  "b532138ce8a181ac858e93e0028070e33f583fa36b34c1e640e3ab7ec8119006"
    sha256 cellar: :any, monterey:       "5b8576f397d2a4d700e9b868065dc801ea4f877f8c98b928266d28cf3ed17286"
    sha256 cellar: :any, big_sur:        "6a50c299a96971b28cb098ce775687c000b0b1cabc0cfd661f54c9c68fdf6932"
    sha256 cellar: :any, catalina:       "64f469134d19439ab3806aed08ddc91430ea1c75e1a6e7a863110e7e1f0266bd"
    sha256               x86_64_linux:   "84718c35acdd16fa7472ebdfbc6cefd8ee56a593bd0600e5c561b180465436b6"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
