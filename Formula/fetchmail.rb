class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.19.tar.xz"
  sha256 "cd8d11a3d103e50caa2ec64bcda6307eb3d0783a4d4dfd88e668b81aaf9d6b5f"
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
    sha256 cellar: :any, arm64_big_sur: "a5b54bb2ed9604db58d4700f10fa5262b2229a1e94d61d9ee17c83e2b846fe16"
    sha256 cellar: :any, big_sur:       "72e602538312c10a90fd93802c277c3daeb09d47fd3bf4f38fd5147261ea34a5"
    sha256 cellar: :any, catalina:      "3e08bfd4efe2465349d622121fc7ac9d9e220f55fd5033b490e0a549bd62d86c"
    sha256 cellar: :any, mojave:        "da04bc6368c92a41930a719137ce9dbd5dd7156eeb17c50e17f66391a9456514"
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
