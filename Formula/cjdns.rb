class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.5.tar.gz"
  sha256 "c7a8335b9be0b53f6d78427e318dd52d93e0e7bea95850d994c241813e6e5e92"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5939291f77f7f90d1867c7f1e001da71d388b04a06742d8895cbbaf4d3a06971" => :catalina
    sha256 "6f526ee74df572fd99dd6641732040e5f147013d30d2e4c194c98c3c9acc1f61" => :mojave
    sha256 "589b70433d38ef5b7f5b04553b4a200327797c35836cb36ae472325d4855eb4a" => :high_sierra
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
