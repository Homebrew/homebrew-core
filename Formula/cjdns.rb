class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v18.tar.gz"
  sha256 "57e5fe05b9775daf16f23c16c24035a4e380a3c9461faa2e1bc9de0bc6b147ab"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb9eb5205e5e55b5ec4e0d0e7244de8361573925acc991306bd39bfd41e16d93" => :sierra
    sha256 "d9d9653337e61885496efb25bf5642ba3fbcc7619f695b3321ec37b04ebd915d" => :el_capitan
    sha256 "c1e288bdd1bb19f7dc4c45e91e3669d36de6b9036b1e4575fecd2b946b0bf5f1" => :yosemite
    sha256 "4e6d7130d6cd52efcab254e3bca0347a5931597215cd48bccf1bf7c1e600c498" => :mavericks
  end

  depends_on "node" => :build

  def install
    system "./do"
    bin.install "cjdroute"
    (pkgshare/"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
  end

  test do
    system "#{pkgshare}/test/cjdroute_test", "all"
  end
end
