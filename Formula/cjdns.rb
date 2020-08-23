class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.7.tar.gz"
  sha256 "de8a9d1afacfa1147bb12bda6d382f30437d424c75d04a7895c2ccdad4d26284"
  license "GPL-3.0"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdb020edfdc373f79126dc0a6044eeaefb9c437093c4ddda3348f3e84aa08453" => :catalina
    sha256 "bd9dc1b933a12a0523dd03d313c15c28d91ab9161ae1c4455fe2d53e228492e9" => :mojave
    sha256 "e71b7e72ae93a10a1cc26c39ef866d46dda116a0fe50ecb452a257ad631d3a29" => :high_sierra
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
