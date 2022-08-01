class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.32.tar.xz"
  sha256 "3ee7444665606ad06fb5f7b15f91e3173b845bc98b646b1a4514a46aa48b7228"
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
    sha256 cellar: :any, arm64_monterey: "95a454ff4c733edcff83be104fd94cef1886ffb4930d4e4a17c8dbd300069a95"
    sha256 cellar: :any, arm64_big_sur:  "2f789ee52867688896da0998c3cb3bd60a75c99450a8b8dc881e4b1cd7026216"
    sha256 cellar: :any, monterey:       "a635627e32189a1ba0dc9f2d2b8b7cc251559007d987dc07e6f950274f0612b9"
    sha256 cellar: :any, big_sur:        "a7a827beadb201e4b0ce83d9336ab5ef178b2e7ec93871ad72308f4ac90d6ce9"
    sha256 cellar: :any, catalina:       "e4389d3ec951029222b15652f35fc1091a8753607b66f1ad7ec93a050e52dcdf"
    sha256               x86_64_linux:   "8739bf253f025d01d9218710167e5280185bd201232aeef05077ab80d387481f"
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
