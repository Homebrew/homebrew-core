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
    sha256 cellar: :any, arm64_monterey: "13e667f7d8bcd32ea5ce2535948ba302bdf2d6d93976d2df7e4af9e4f7d2edd7"
    sha256 cellar: :any, arm64_big_sur:  "8856e54cb2529de54d6ad058b294d0e49f8933bf5f611b47eb189f5e05b322a9"
    sha256 cellar: :any, monterey:       "d9a3dc3e5dfefff402eedf98da7a0ac1a20df92c77eb52a85723410371da26c9"
    sha256 cellar: :any, big_sur:        "4bcbec8680eebf363a22a217d0951c2b0350ce70a64c047eb46da92bb0347a29"
    sha256 cellar: :any, catalina:       "106edb1d1d6677b7fdc3b3f8d76e84d9eae22dbf56a5b45a7c5331486687087b"
    sha256               x86_64_linux:   "08e7fe9b3448ecc3259b3cf5ca1a24fd18c4ebd0c39266b99583a1b87d03162f"
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
