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
    sha256 cellar: :any, arm64_ventura:  "ccbfc5c57049d74a455b25e579332d416c822ced8dfe7f814c6dba0aeeb28a95"
    sha256 cellar: :any, arm64_monterey: "cc9f08926e10e29fa015a543aff8e6f8cc26949bcb548011265d3d5c7cfb9199"
    sha256 cellar: :any, arm64_big_sur:  "4646ca118b2cc0432b5737bc91dcac6e4583671ba54300fe44ade2c6204fc1db"
    sha256 cellar: :any, ventura:        "e9973922c9a0633e5d4c8a45992db42886c7e9ed43c6ae45f24b7ee0ea1935f4"
    sha256 cellar: :any, monterey:       "ac1c1e07a255b9d4446d942d142729f1e572dabdb71cb39b7b5542b4e89fbb06"
    sha256 cellar: :any, big_sur:        "717c5476915d9ff3390ee9e05da0f3cd1bbb8d2d455ef338edacb84aeb1754d7"
    sha256               x86_64_linux:   "26c20275fc354b2c2828ae3c4cbb616a23208b6cd06583f1d06e54410f183be7"
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
