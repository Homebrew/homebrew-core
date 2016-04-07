class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc/archive/0.2.1.tar.gz"
  sha256 "cb8d6830565ab6b47ecef07dc1243029cef962df7ff926140022abb69d1e554e"
  revision 1
  head "https://github.com/ponylang/ponyc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "767013d4ffb5ae596f17282b80205034601f029b649b8b5e428fde32ca5e27f0" => :el_capitan
    sha256 "08857152c0ba5a5dc00b96a7e3d1c47a8ef4710dca6262e3eae0dd90122b29f3" => :yosemite
    sha256 "007c43a75741ecd4c7c96c9fc67d816ebc845c0aac94687c4e2cbb1ee959ebfb" => :mavericks
  end

  depends_on "llvm" => "with-rtti"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  def install
    ENV.cxx11
    system "make", "install", "config=release", "destdir=#{prefix}", "verbose=1"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"
  end
end
