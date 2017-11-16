class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.1/opensaml-2.6.1.tar.bz2"
  sha256 "69516b165858d381fcf1d8ce809c101246824d383aa635a3676648c88b242a83"

  bottle do
    cellar :any
    sha256 "53a7172d8fbfeea4b1acfcde23f32ad59c295bd796eb4c5e452c60bd6397b3f1" => :high_sierra
    sha256 "147bad128c934be0b779bacb53a50fa46c1979436b9f22c0511f90048121e6ab" => :sierra
    sha256 "c36e08e7dd5ad30c3bd75e7eca30615274d21c9339c7ab62853037dc2e1d9f02" => :el_capitan
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
