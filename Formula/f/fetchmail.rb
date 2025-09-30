class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.5/fetchmail-6.5.5.tar.xz"
  sha256 "f989b62729c76afbcd65ec43b9c477f2d990f0913da141ff8166aa4e2bf56025"
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
    sha256 cellar: :any, arm64_tahoe:   "baa266899a5d0762c1c8de72d66172046d16a8936d916d59ecd38949b810355e"
    sha256 cellar: :any, arm64_sequoia: "2d3cc96ba9eab37a4c90e69e0ded42da4d317aa71c50bcf9d67b423ff13fd99f"
    sha256 cellar: :any, arm64_sonoma:  "5636b1a32fa0c3dc428a71ab1414ef56270018513807129d25e56d23d401fe50"
    sha256 cellar: :any, sonoma:        "649c97111eb7de63e1f5090278cb6570553750672b13a61e8643ddd4b8c5a28f"
    sha256               arm64_linux:   "4095e91d22c75dd76b6caa077d73335a232c9b878aabd0171925ea83633a1a79"
    sha256               x86_64_linux:  "681ef55b7a2f8d0c6e4e650d252a4cab9c04288cac8706c2c88680b50a578d1d"
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
