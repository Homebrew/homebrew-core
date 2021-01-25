class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.12.tar.xz"
  sha256 "5f6355b52d9c360619623a40c66c1a5571e393b43fe58375c0de35429ac3480a"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 "6e1d0e59df73534ec28952b1a00fc490335959c5da636306ba3f2224f1f5d995" => :big_sur
    sha256 "3aaad5f552e6c7b1dc2826e17fde83b873f63d540607a83edf8f0d9466dd4be3" => :arm64_big_sur
    sha256 "8fa53695d0f74cb8575a6eb1b3582ef2e06814c1540c8c3ad20be5f9667f617e" => :catalina
    sha256 "8c30103713ed7538025b297aaf50fd072dfdfe3fe803ee0712f8d06dddb094f3" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
