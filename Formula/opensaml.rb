class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.0/opensaml-3.2.0.tar.bz2"
  sha256 "8c3ba09febcb622f930731f8766e57b3c154987e8807380a4228fbf90e6e1441"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "7ff16ab9ae108bfdf36b413e0c11f297704b23ad09b444b50ead14497bda02dd" => :big_sur
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
