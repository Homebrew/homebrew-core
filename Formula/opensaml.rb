class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.0/opensaml-2.6.0.tar.gz"
  sha256 "8c8e7d1d7b045cda330dd49ea1972a3306ebefbf42cc65b8f612d66828352179"

  bottle do
    cellar :any
    sha256 "0b87be07f29c5a51d80cfac49829f0936e1454a252d1e9ea2d40131b44e9c8f9" => :el_capitan
    sha256 "45d550de2758f91714237f8d9f620163e2b385ecd4fb339675c7accbe87670d9" => :yosemite
    sha256 "b2d6b8fa31fbda9fb4a9ad5ae51ba2a7b61cacea3108beaafce41f2031ea7e53" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
