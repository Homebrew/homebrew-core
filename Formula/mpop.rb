class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.2.8.tar.xz"
  sha256 "16c3794507673bb1e6e8a9231787594155f32e5c68a901368045cf458f6a79ea"

  bottle do
    cellar :any
    sha256 "b2594cbd367ac7c922b279764df9f51ce8684218cd800509dc1a0c13c35a7b25" => :mojave
    sha256 "648cdecc606fd477c7949a81b0c4dd4d83ea4e37fb44fa046562563b29653bcd" => :high_sierra
    sha256 "4f059bd22ca42847af9e0a109d1753d50a9dc08dc2241e6efb009d5589919bff" => :sierra
    sha256 "4a11baf2addbf2be8122ea578cea50ebacaabb0f5ba60565b5d42c58c9e889b5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
