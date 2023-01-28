class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.36.tar.xz"
  sha256 "700d433838d3e29e304452aec56b21874f538ec24113fdcbb25139c5f2edc23a"
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
    sha256 cellar: :any, arm64_ventura:  "2cfc6f1ee53f355a792c44f9ad1acf3ce441630f7243207bf5b0ffdfe6bcbf9b"
    sha256 cellar: :any, arm64_monterey: "8942bda75bacb4325eb047e95bc080c4b14ad674e0ea2029f596824bbded67a7"
    sha256 cellar: :any, arm64_big_sur:  "22adb075c1d00d7dba56ce716735dd60aa8e5621d1fb62f36ced3c8debb5d9fd"
    sha256 cellar: :any, ventura:        "bcdfc06a8c6278d3f3ca7c5b7d4b40b6dad9f7dc00f96b6dc11c4661e70b8cf4"
    sha256 cellar: :any, monterey:       "a52c55d1e1b88b4cc6bae0f3901dc1bdc4a172b242bec7cf357866ccf9cbed2a"
    sha256 cellar: :any, big_sur:        "f34117d5c78375fdbb26cd3a7cf735178d8bcc5c2ed62b4244055969344b1ab0"
    sha256               x86_64_linux:   "54c64b2799e17784f65473db0fe096967533d694beab4b81365e9c96a0cd608f"
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
