class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.1.0/opensaml-3.1.0.tar.bz2"
  sha256 "7b632d2cf6556b213e80ec1473b5298dbfa17f665cb3911f933c4ad5fe2983b0"

  bottle do
    cellar :any
    sha256 "fb766a10e4471cb65da1e9833ab752e360af38a598f50fe4190881950abed391" => :catalina
    sha256 "06438e82b7723985c2089d8ab2198dc8ac7bfc0cf3e86c3b78c0bea8586ecb41" => :mojave
    sha256 "55e58f4e0e0a077ea5dc4a936e759a9f5e710fab05b2f9f6efb4b01144130d3a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl@1.1"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
