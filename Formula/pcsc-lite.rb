class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.9.0.tar.bz2"
  sha256 "0148d403137124552c5d0f10f8cdab2cbb8dfc7c6ce75e018faf667be34f2ef9"

  bottle do
    cellar :any
    sha256 "650bd1cb922417a5ef04f6667261e9b11393ebbd24750f6332ed067716a5e192" => :catalina
    sha256 "fca41c0447251ec74156c0dd68e6b38b695d9f14d7176c329964c223cfb983e6" => :mojave
    sha256 "4fc95dd4040b9ac313724c6db99937949dc18013c8a59839f806885e0d5e2e50" => :high_sierra
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--disable-libsystemd"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
