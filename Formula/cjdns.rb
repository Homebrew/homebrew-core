class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.2.tar.gz"
  sha256 "b114f4e89c971d2c288e3d8265396248a37134895b0e0468bf55030de84b4d2a"
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
  end

  test do
    system "#{pkgshare}/test/cjdroute_test", "all"
  end
end
