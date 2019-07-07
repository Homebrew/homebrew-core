class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.3.tar.gz"
  sha256 "e8ca2cc5d5ba71e39a702299106dd2a965005703284cec91b3e94691cdce6f65"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62b8418625dc9550f4eded4ee1c7062b8c5d85da97aacd6899fff13578d3a836" => :mojave
    sha256 "5e516be5ce8d028803865ce5ea136ccc671250424f560efbd6ab1454976ff42d" => :high_sierra
    sha256 "0bd392fc17fb41ad9004458c0098df2dc165accf5c9d676efe21373c22f857db" => :sierra
    sha256 "095639122e0a992531834d8c1b77113386064fa6214eabf06a0716d3ee678291" => :el_capitan
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
