class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.tar.gz"
  sha256 "08a1029d47f3b666eec9d901b2e2fe6e8f971348c10465427db95e4153ecd8b7"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9126208cc88fdc96ebf63ac4eec3b872127a81fee599e5c258cd48dc8ebb5a85" => :sierra
    sha256 "ad1a0398f7f4c9336ae2bd87d61ce4ab25bce3f670452c6c55a01c5b9cbdb250" => :el_capitan
    sha256 "5a04a85d79d80a1238b5d2afeb5fb18a114555b0cd156c09bbd3f13c8af07a91" => :yosemite
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
