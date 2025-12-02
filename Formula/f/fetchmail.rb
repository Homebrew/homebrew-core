class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.6/fetchmail-6.6.1.tar.xz"
  sha256 "38d01fe404e67514df394a6ed1a815bbb61aa90c0fa4402252593aced0e38a1d"
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
    sha256 cellar: :any, arm64_tahoe:   "1e5aad87b142f8508d48e70a0f71df5d25f74eb91ad6700b016f80884c1b2a8b"
    sha256 cellar: :any, arm64_sequoia: "b3c0dc3045a8d0e72d907cdf4cbc64fd1527da0a15bf0795770df6378f4e3998"
    sha256 cellar: :any, arm64_sonoma:  "a4edf647692e84c117f1b414a614ac82c1027a5c5486dfc476ee7c656185fb1d"
    sha256 cellar: :any, sonoma:        "db1b4a47f4ae77673089eda86a654d31e90b1e211a1c6401ec10bdf38ccc90c5"
    sha256               arm64_linux:   "f7628cdc9128b89d7805bb35be58f781743236c5b2e812bfa62b6a619e0097e4"
    sha256               x86_64_linux:  "08a3ef52b092730dc0f74c2b6479d725c357561129431ecc065eea339ca1c8ec"
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
