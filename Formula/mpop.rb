class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.15.tar.xz"
  sha256 "3f52b2b5d4bc58ed93cf0b1146cee4f74de81c2c07a25ee032efa659465a0270"
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

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libidn2"

  # Both of these patches are needed on top of 1.4.15 to fix build on macOS.
  # Remove in next release. Build dependencies autoconf and automake can also
  # be removed in next release, as well as the autoreconf call in the install block.
  # See https://github.com/marlam/mpop-mirror/issues/9
  patch do
    url "https://git.marlam.de/gitweb/?p=mpop.git;a=patch;h=68693b7da5d037ac31954db00c210daa28f2ea74"
    sha256 "f6bc137aaa6c8bcf6b608167108e2d2d4d255f61f7323d789da4cd028ada84a2"
  end

  patch do
    url "https://git.marlam.de/gitweb/?p=mpop.git;a=patch;h=64f8dc2b39d9e967e09b234993e096f4441ae87a"
    sha256 "f920d7897a38de14f30388cc3f62200992ab5bd054e5b250085af013590b3607"
  end

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
