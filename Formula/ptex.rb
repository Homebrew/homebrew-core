class Ptex < Formula
  desc "Texture mapping system"
  homepage "http://ptex.us"
  url "https://github.com/wdas/ptex.git",
      :tag      => "v2.3.2",
      :revision => "1b8bc985a71143317ae9e4969fa08e164da7c2e5"

  bottle do
    cellar :any
    sha256 "a42bf621a85a3755df375259480c9dead29f2bdfd2633ed996d7755d8ef95b51" => :catalina
    sha256 "e9065c4a5ec4366e5e105fecc9035bd2e3f3e36335fd042b20ce23ab77549d2f" => :mojave
    sha256 "7f500b3f83df7d629ab757f75549f33c04a36c7fc357b3bc724df08c3e9cd249" => :high_sierra
    sha256 "9b72606a8f4d057d00bc0bcd7b54ce16873e345043b3f877cf17e723aedae863" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "make", "prefix=#{prefix}"
    system "make", "test"
    system "make", "install"
  end
end
