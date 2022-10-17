class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.34.tar.xz"
  sha256 "c3bdded1b5ce236960bd1ceeee3f3257220ed99c3eec84a5d76bb5618e3258d4"
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
    sha256 cellar: :any, arm64_monterey: "b2227372f433105e774806a29fc0b08297fb68df864a1eebd9b890a9f978a685"
    sha256 cellar: :any, arm64_big_sur:  "08c5c2242241fa8095687f922b9876cd804578abf32928bed7bfab0ed96d4dcf"
    sha256 cellar: :any, monterey:       "b5d9c462428d6f9d8212c447f6723181c02c3b5ac982b090495d122f4d0234b6"
    sha256 cellar: :any, big_sur:        "e0b0e0537db1e1d4e9489777551048876091d1b9cf3d695667cb2fac76ece9d3"
    sha256 cellar: :any, catalina:       "d86c60b1dc2ad2b3e652268902c03a5f4898ca04fd22b6fbc8ccf9af490ccfc3"
    sha256               x86_64_linux:   "e0daa49d006bf734567eeb4faedb193b5827d32e2c15840eb5a847582d7b817c"
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
