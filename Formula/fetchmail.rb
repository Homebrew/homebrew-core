class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.25.tar.xz"
  sha256 "7ebefbe89172fd59f0fd8317d8743a8436f375ccdcab3900e4c3ec06a8fbf27f"
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
    sha256 cellar: :any, arm64_monterey: "b754c0ac9caaf2cfa690560ccf6dcbe67ce0379787176f2290b2ad4d56e09827"
    sha256 cellar: :any, arm64_big_sur:  "28b90ce208d36ba5c4c04b7452ce93ff1cd07e3c6a6e91793fe0952edecfbbb5"
    sha256 cellar: :any, monterey:       "29d51ee82f19b3c02460d2b0cdbb602018104e30a980071fafb824fefa8afd3a"
    sha256 cellar: :any, big_sur:        "bd0169b65b70924be230cced18c5db74673bc64fdfb3d25fad83b93e07e57761"
    sha256 cellar: :any, catalina:       "b40a8bf631ba4706274a58120b3bb49271a2c42e9ca333821157e911f57e6a26"
    sha256               x86_64_linux:   "8b9a03038f6e69b947c71207f885f475890772304d1dc1e148a4de06b0ed4aaa"
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
