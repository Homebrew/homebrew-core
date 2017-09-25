class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.0/opensaml-2.6.0.tar.gz"
  sha256 "8c8e7d1d7b045cda330dd49ea1972a3306ebefbf42cc65b8f612d66828352179"
  revision 1

  bottle do
    cellar :any
    sha256 "15d5da7716eca786b383137e874bc534104be719f5e607e8a965df6c35f2c9ef" => :high_sierra
    sha256 "69da309a2c6a7fc98779f96c886a21483369ec5852ea17ec0fa7d1ba2b26462e" => :sierra
    sha256 "937b54e18b3534e4d0347387d1643300a9c53bcbc1d308fe5266772234bc1c8d" => :el_capitan
    sha256 "322d88659baf80f401e97aef470337968a5d33d951fb0ee26bc05f1740557aaf" => :yosemite
    sha256 "7d6cc9c8b4a616e7e44e703919369d9b9cdf8cd49635b461ffb3608348745814" => :mavericks
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
