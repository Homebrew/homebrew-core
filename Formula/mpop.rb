class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.16.tar.xz"
  sha256 "870eb571eae6d23fb92ad0c84d79de9c38c5f624e3614937d574bfe49ba687f9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2f8a61fece9387f48d48100bd845a5d663c250692a87ea06821d4b6f23f6e2e0"
    sha256 big_sur:       "23ad8bc64b32e93f151df2005b1160fc46f6c039764e18c4a7a42ce4140c6350"
    sha256 catalina:      "0555359b5c2935c7646ed26596e4b731b037fcbf49cd01f94d533d7701e39825"
    sha256 mojave:        "ac8892c6d8ec4142a3bd053ec53b99d678a4069ee070f40a0232c36283641a10"
    sha256 x86_64_linux:  "d10d8a7e75b2dfd1c05bad7e92a870b934129317fedc3c37ec3f3f195d38f876"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
