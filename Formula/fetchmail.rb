class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.35.tar.xz"
  sha256 "7b0b56cbc0fca854504f167795fab532d5a54d5a7d3b6e3e36a33f34a0960a01"
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
    sha256 cellar: :any, arm64_ventura:  "0e72f8a593bce8f6b70ad0f865587e79bf2eac97170d0db4726aa4aa6bb81641"
    sha256 cellar: :any, arm64_monterey: "6c2e7623eb53d17c633555b5cdb0659061cb0b0bad7af40252ddcec2aba3a45d"
    sha256 cellar: :any, arm64_big_sur:  "50772adf604e9205c592503137467f95ae53cb04722baed139899e1ed6a86211"
    sha256 cellar: :any, ventura:        "997cb4d44910e0f88c6b8b8e72a7e25f83b2b8abdd95b9e7d208d499d57afa56"
    sha256 cellar: :any, monterey:       "ce494d0f16574c490c6e06cc1019934413f629674eac8c4f241c8326fbf8e5cb"
    sha256 cellar: :any, big_sur:        "031dc3c1d190d75404ae239491861e194ea0c5bd660823585d56f41b56e36ae8"
    sha256 cellar: :any, catalina:       "748117a27ec5bb18475ecc9707dc350e030eba647a160b00d720d6f6512dd215"
    sha256               x86_64_linux:   "7b01de3652afe1f7ac3adeaf61d92c6fb9002883afb2030267f563890925a7f2"
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
