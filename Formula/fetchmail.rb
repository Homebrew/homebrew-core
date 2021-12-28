class Fetchmail < Formula
  desc "Client for fetching mail from POP, IMAP, ETRN or ODMR-capable servers"
  homepage "https://www.fetchmail.info/"
  url "https://downloads.sourceforge.net/project/fetchmail/branch_6.4/fetchmail-6.4.26.tar.xz"
  sha256 "2cc8a94bfaaf794687b2b2147786508f30da598d1ab035c345d731928ac40c9a"
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
    sha256 cellar: :any, arm64_monterey: "b36b69457bc554572b7cd7675b193d061adb314ac5046916defafa7503d3660e"
    sha256 cellar: :any, arm64_big_sur:  "8f5dff2126beff1b32941de8cdd855746c7681ac62cd45151ca606600b939084"
    sha256 cellar: :any, monterey:       "08fe40089c658201f745c2b5e33ad9415c4b0d69a421100606af2862380e5757"
    sha256 cellar: :any, big_sur:        "d2a37e714407531bc8ca723b50d6bab21aeda37193f47a23a5c22f488061c3a3"
    sha256 cellar: :any, catalina:       "79f64c9c6242452888cbf6955dee232cd5fe35151432bd2d61a8ea47095e6369"
    sha256               x86_64_linux:   "134a776ba2bb117a4b384cd1df4a6c8525d0b06dbbf6628f645a14c8ddd09c2d"
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
