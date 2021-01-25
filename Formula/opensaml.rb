class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.2.0/opensaml-3.2.0.tar.bz2"
  sha256 "8c3ba09febcb622f930731f8766e57b3c154987e8807380a4228fbf90e6e1441"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "220a34c0915da2d3641b88d96615138e7a5341d4e21cfa654300a6ccab16651d" => :big_sur
    sha256 "28d745aaa6bc776ee02233852c46e2aeb4aceb7bebb18544616636afeb61867a" => :arm64_big_sur
    sha256 "09eb04c9b5475a70c1cd95e13e349c30c650433a0908fb078cf99f7126c4c4c5" => :catalina
    sha256 "24938a715d29e9db821774514452b5b1289ce243c5a48c1a492286234ed8c945" => :mojave
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
