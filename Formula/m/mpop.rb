class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.19.tar.xz"
  sha256 "23c41e13c6ffebcaade2c36c9fd462bf25f623e481bb0627cfe093e03a555c8a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "38675083a4bbb7a2ca156db5d3a05ef0ac6639ffd6a131c3ec01f37ec934ef25"
    sha256 arm64_ventura:  "9569cd8b77b9e70524e550e207af1b04e404105e1690e070149807e718a8e938"
    sha256 arm64_monterey: "2e16713ed91d453aae5bb75537521b7c370c0a6e706d7caecdb3f417e5e89ce9"
    sha256 sonoma:         "7414c4739107633e726c61d6f8a6c2052b1609fcaeae4815335da45e22f8dffa"
    sha256 ventura:        "c33e788091e865eddd2c7eb878565e815c320526bc6cd5dcc3e85d2e5fb7aed5"
    sha256 monterey:       "36039ab4f8be4481635985e4616dc913191388c0ede93f3100b969c41d0658a5"
    sha256 x86_64_linux:   "541faa45b94d68efd6d56a57a48a722ac0f6d77caf3d2b9c37268ec8883967a1"
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
