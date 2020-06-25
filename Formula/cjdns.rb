class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.7.tar.gz"
  sha256 "de8a9d1afacfa1147bb12bda6d382f30437d424c75d04a7895c2ccdad4d26284"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2aa7cb574b1cb8842dfa30363202b6cd2eebaefa1eb4153eeb5965ed5ea7190" => :catalina
    sha256 "096f9ea9e146ee59ca7ccbf4137c61446f5628d8e00b3ebbd4d1ac2c9d37ae43" => :mojave
    sha256 "6a094d89765f7f286097c855da073885423757e460a30f664ea15ade8810e397" => :high_sierra
  end

  depends_on "node" => :build

  def install
    system "./do"
    bin.install "cjdroute"
    (pkgshare/"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
    rm_f "build_darwin/test_testcjdroute_c"
    (pkgshare/"test").install "build_darwin"
  end

  test do
    cp_r pkgshare/"test/cjdroute_test", testpath
    cp_r pkgshare/"test/build_darwin", testpath
    system "./cjdroute_test", "all"
  end
end
