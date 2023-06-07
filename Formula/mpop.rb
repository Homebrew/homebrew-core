class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.18.tar.xz"
  sha256 "6099950184f7d094a782d1e7ab9833736f12308d34a544a59b46a8471d9f85b7"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0cb57fca35ffe7fddc6e474f81ab63b60555dffe4202a86ab9fa741c784e1b49"
    sha256 arm64_monterey: "ca57144cd013c41caa043663fb211fb21dbeaa965cf788393a8f7e96e83dcb1d"
    sha256 arm64_big_sur:  "fd748cc2f7d85ff93240a1941ab5320a14a05676c51e922c6fd12362a2f3f339"
    sha256 ventura:        "f4846cf9268fe45b354912dc8353effe2e1bc0b329887291b036ce5953ea3195"
    sha256 monterey:       "d32f190cdde4f59a0a16ea5981ad7f837988dd52ac49d6c29431f7aace86ac61"
    sha256 big_sur:        "fcd3897a5efca4a72b8dac253f2937c228e2a4efc269d602ba011074ea070e39"
    sha256 x86_64_linux:   "9dfed437057c0932e7c85990a5417a81d5c6262d588925d089c0da66a10a0e23"
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
