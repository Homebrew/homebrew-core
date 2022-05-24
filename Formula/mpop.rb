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
    sha256 arm64_monterey: "762d29a253ab63afea52f49ef0380a6530e6261e3050361206e9122e5a4e3c49"
    sha256 arm64_big_sur:  "fb83315e0e06e5586ef99f2dcbabc7cf248744cd72c736615c08c6c93f5ac809"
    sha256 monterey:       "ddef337f0853edbcbfe4fb7d408eb5cfd3ccd2f459b645ef510a21e49093a6a7"
    sha256 big_sur:        "9b42850fdeb9d94c15228333ec8537b0f39ce90f5ad799729706113b97d59ee3"
    sha256 catalina:       "16273c6c9296a2aeb6724a6c0c023c2c83ae8304f90c78cd8efbd9dacd3475c6"
    sha256 x86_64_linux:   "a14a672f256617064258a4d0b1dbe96b30e39fb13aef5c1c6397873463766a26"
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
