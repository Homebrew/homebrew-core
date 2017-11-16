class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.1/opensaml-2.6.1.tar.bz2"
  sha256 "69516b165858d381fcf1d8ce809c101246824d383aa635a3676648c88b242a83"

  bottle do
    cellar :any
    sha256 "465fc254c7398254be2853488c53ca06c490dda783bbfc3041a5031a3e0507c4" => :high_sierra
    sha256 "dc7242ca3ea9c197b99c2a1f9ef1fe4a752a8d170656e045c524b87d48bce9c2" => :sierra
    sha256 "db4e0d6d46638982c5fb0c90cbd9aba13696761533c025c7852c4b4dbf5bc567" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
