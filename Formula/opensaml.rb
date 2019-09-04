class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.1/opensaml-3.0.1.tar.bz2"
  sha256 "80c1672929e3bfc3233e5a995517bc678c479ad925f0cdf9cacffaa7c786cc29"
  revision 1

  bottle do
    cellar :any
    sha256 "2e3de9a9fae0e0a3b661e2ca51998d24e7b184752a8864168d1aafdb77e87e9e" => :mojave
    sha256 "1bc086d8190a91f9362b3243ce06cbd35afd81cc3302c22ebd14e50126b74986" => :high_sierra
    sha256 "86a90e8db72e4fe9cca64f073240f2e458e3a1019d47b9f014ef950c5d92b057" => :sierra
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
