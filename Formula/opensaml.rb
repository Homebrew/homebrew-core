class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.0.1/opensaml-3.0.1.tar.bz2"
  sha256 "80c1672929e3bfc3233e5a995517bc678c479ad925f0cdf9cacffaa7c786cc29"

  bottle do
    cellar :any
    sha256 "14d2c6a9825c4bb74b9708fee49cfe4466537918bbd913d795b4f66256721996" => :mojave
    sha256 "a243122e77ac69b74e01e69201b8bcaab5499b9b6859bfa11f7dd5e6e5bd5da9" => :high_sierra
    sha256 "5287589b2ee6abc84823ea9e39fff2352b790876df6a4cea1251358926738476" => :sierra
    sha256 "2134b9b9be0a181807065f905a874639d2fb780e50628cb6c365e889e65faf32" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
