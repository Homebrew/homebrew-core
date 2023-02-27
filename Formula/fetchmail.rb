class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.37.tar.xz"
  sha256 "4a182e5d893e9abe6ac37ae71e542651fce6d606234fc735c2aaae18657e69ea"
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
    sha256 cellar: :any, arm64_ventura:  "5316919eb1cc3882ebc53e327cd3c2e17a38c7bfcb81be281c4b92966b1dc65d"
    sha256 cellar: :any, arm64_monterey: "657d3908e12e418cc7f2544245ea57292d684a4419b421becee4da273df6b340"
    sha256 cellar: :any, arm64_big_sur:  "af2eab37dc251bc0babd7ae51aae3e5b1c1092c917fe116544243f606e744d49"
    sha256 cellar: :any, ventura:        "2799f31acbf5149807d4d23ca0dbb37608ba7ddff8046cb573466094a774914e"
    sha256 cellar: :any, monterey:       "f47c6067b92367c00e744c294bab6b73f9323bce4d4ad63a95461ebb6e29b680"
    sha256 cellar: :any, big_sur:        "f697f371793d6bfc56a66dfcd6bff017afa25397b025e10f079c7b04b92cc882"
    sha256               x86_64_linux:   "33f7f29c10df5e923df692fc65bcdd002f7e011a254ff6d8598873183214a352"
  end

  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fetchmail", "--version"
  end
end
