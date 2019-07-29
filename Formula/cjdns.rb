class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.3.tar.gz"
  sha256 "e8ca2cc5d5ba71e39a702299106dd2a965005703284cec91b3e94691cdce6f65"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d19900f4469f6da94b225a6b5bf54fce7adebfd8178b78934e1c9331108a921" => :mojave
    sha256 "f04a38f22e48d0b8690a3937c22576fbd058a4eb7ff5d9df83a558760b98132e" => :high_sierra
    sha256 "0d9b022ddd9920848a51e46a0ae67f46c81d911b384b093768d74a2adc0d044a" => :sierra
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
