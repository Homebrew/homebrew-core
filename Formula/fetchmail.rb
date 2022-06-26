class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.30.tar.xz"
  sha256 "35824c20aa1d8d97e3f1611fef49b9f7f68396f7cbc4d3a807fed27ae9ea445a"
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
    sha256 cellar: :any, arm64_monterey: "44644c6fdd10173c30ddc0bc48d85ea7dfd18e72e7b2ec56e33610c8eac4412e"
    sha256 cellar: :any, arm64_big_sur:  "5895b3c96bef311e6ac82f52f94877792c037fa86e63a6abce911df64e601639"
    sha256 cellar: :any, monterey:       "8c1e11397e7c65b440397fc37eb12142a099d8c80a45ad3d85ed12e977f82c58"
    sha256 cellar: :any, big_sur:        "c8a56c75eb705a49147ea2fc33bd6bac64773942e5395302cce8d3209d63abb5"
    sha256 cellar: :any, catalina:       "95cd2e811c1fdd8d266f821417084dc3bdcc2e5f072c50bc6337c1a6ce5910f8"
    sha256               x86_64_linux:   "1adcc903c56512782e6781442dc2b9bb466329b2c6e4657b17e2be80f2f84437"
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
