class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.2.tar.xz"
  sha256 "a5109295ec3319e0e45edd009d2d977042a8326ab52c6a817a82fa987103e4f3"
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
    sha256 cellar: :any, arm64_tahoe:   "52ae4f8d948af438737e6ecff27dbb60f5e0b5985f7675657f6dc6a25d000b20"
    sha256 cellar: :any, arm64_sequoia: "2ec075beef02a14da192168555cabaefd70a50230572746a47d3f8ca75f094c2"
    sha256 cellar: :any, arm64_sonoma:  "a5ab2daae7ee8de83520a2f44c9e23df7df51ce782d94a36f25a45853ea4e9d3"
    sha256 cellar: :any, sonoma:        "af36771e465fb908411295ddf164c3690c9b1b646431791efa120d3ceaca3818"
    sha256               arm64_linux:   "a795fec5c4a0582d04b84fafd7b4cee71fd836419c3c036c36009229e4f43cbb"
    sha256               x86_64_linux:  "8942310d36cfc9e04abd493ad0761c414413595d2f96bb02e444104eecb7a75f"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"fetchmail", "--version"
  end
end
