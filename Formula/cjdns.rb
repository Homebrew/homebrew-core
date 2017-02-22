class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v19.1.tar.gz"
  sha256 "53c568a500215b055a9894178eb4477bd93a6e1abf751d0bc5ef2a03ea01a188"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "519c9a9c5a6879a05b47e85f70ee6bccefb878dc605b209504273de88d5fefa6" => :sierra
    sha256 "36fad567a8247329814508b2dfa7b2d343e70e594399ef95e14e3107d0fbb799" => :el_capitan
    sha256 "23eb33042c33c32d9d319aa59a9093f0a0fefaad7d7b28cef390b4186f98037a" => :yosemite
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
