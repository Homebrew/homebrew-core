class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.17.tar.xz"
  sha256 "42ae494bad2941d9f647c48c3ed98c38ba9aa5cf3fe48fb0fe06e5b6dadf8bd5"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://marlam.de/mpop/download/"
    regex(/href=.*?mpop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b5aafa2814cd9bf63d096b80f2a1e576bc69071552987cc3aaa78a117448a17b"
    sha256 arm64_big_sur:  "b024f2373c3240dc0c1614323b9fad2cfb3758a2e9e3fdce4d710adbba95087c"
    sha256 monterey:       "2c771eb6d185b425811775e3500dcbc09dd7fd3042a2f76d008470f2e6d97557"
    sha256 big_sur:        "ff75a36a3b179226f2ac3ce657bfe874b3e19efa4021e169aa4ffadf4438b690"
    sha256 catalina:       "c4d0f71bde8b26706c4c936a836d8900b93b0e892a317debba4c297ece0f5149"
    sha256 x86_64_linux:   "9a9f6f350d632fb8e3b49cc2fc64d2f179192ee444193cb072672a4a9bb05d2e"
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
