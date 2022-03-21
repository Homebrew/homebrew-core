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
    sha256 cellar: :any, arm64_monterey: "8d38a05a498ab06286a18fc65feaa080242ed5c6317ec8ea11af9601da0937f2"
    sha256 cellar: :any, arm64_big_sur:  "24bb3d4619d424fa95207bc23f9cabd85bf00cd0bd5a68103d41a3b3e644f915"
    sha256 cellar: :any, monterey:       "c2266f90c7e5b80cba09f72d889ea169cad5f1da22b2f0f68453f4129b467a32"
    sha256 cellar: :any, big_sur:        "8b4536d09127dcc561f0752beb7e6f24aa1aa29d41f2c4454b419b5d727097e1"
    sha256 cellar: :any, catalina:       "64d61cf78e9715b183c49eaeab6ca977a1e64714a1a7abc7c2d8e6158837218e"
    sha256               x86_64_linux:   "c7419e695d774ac56baaa54406e5e7f621a2b444464f21e72f8adec2c90c42c0"
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
