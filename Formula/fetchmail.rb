class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.28.tar.xz"
  sha256 "a003f9ac88bf083a232c9451ef5f3f88473fad2c7f2822d3f7455a6d32bc3a97"
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
    sha256 cellar: :any, arm64_monterey: "b7918eb83d9206b2f5d6a4ac3474d2f7e153d9f9065d4cd8c6ad0f5885875516"
    sha256 cellar: :any, arm64_big_sur:  "ac938b3dafa14d3098164af49e2bb3696c8db1b5404ed10ad91318057112daaa"
    sha256 cellar: :any, monterey:       "48e28fba11719b7dd35153d41845acf27e5f2c6c0a901c8b8f8297cedec107e2"
    sha256 cellar: :any, big_sur:        "d09fa77e280cdaf2d9ae2ed947a308d62690fb70b3b25a59a62527fe21b58b5c"
    sha256 cellar: :any, catalina:       "1527f83e06ad18fecfc4f42e31938f131d70e7c6c26034f40fdb4e74979d287a"
    sha256               x86_64_linux:   "8f57b6b2afb134fc87083732fc551abef578c2aa9c6fc8f16c85e82b0180217d"
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
