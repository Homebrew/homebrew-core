class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.4.tar.gz"
  sha256 "e73246925954c2e2779a936af9b5b4f1def54865ea0ae37127dddc25f5617bbb"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38cfee60488cf26592588ee1b62f77df9e430d82d4596cc69728d4a1cc134cae" => :mojave
    sha256 "7d1b80dfd3e061d76febf4bcd68f23ec9f0dbb4ed5a85e0ccc856434ac7c31f9" => :high_sierra
    sha256 "9bb1b9a52248c090e939ae865a838374143e2895a59f5157b93aacb22c7a223e" => :sierra
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
