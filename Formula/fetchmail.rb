class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.21.tar.xz"
  sha256 "6a459c1cafd7a1daa5cd137140da60c18c84b5699cd8e7249a79c33342c99d1d"
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
    sha256 cellar: :any, arm64_big_sur: "9c37c3d5063c09a0ca132b18064fa6d2eda4d516f53969ee6f695c239630bb61"
    sha256 cellar: :any, big_sur:       "c34771d216483c30ce64005dee9244ae6e882de8dfd5030bfce77c8104f7ff7f"
    sha256 cellar: :any, catalina:      "fa15893187bf723eee6f3624ac37fed1071f66ff33a5b299f8680dbc2f499c27"
    sha256 cellar: :any, mojave:        "e3db7a24a23a0927d406aabea1418e1df3a89227a428a8174cf316e7ab91198a"
    sha256               x86_64_linux:  "1b4f59ee90de90372a1a9ef5c91ffec9277651d9d515ba1f7f0768ee50e0d8dd"
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
