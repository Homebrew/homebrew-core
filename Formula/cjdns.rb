class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v19.1.tar.gz"
  sha256 "53c568a500215b055a9894178eb4477bd93a6e1abf751d0bc5ef2a03ea01a188"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65d902b682b18871771255731e43edcc2b79d0433df84c69706760d4e3bbb4d5" => :sierra
    sha256 "9f4cb38fb83e732205dbb81a247d466d97a5b759f91fbf8b0cc65df12116fb20" => :el_capitan
    sha256 "33e2dba73aacd5fabeee29da7ba317d1c555cb0a4a48b77154db0155e234a601" => :yosemite
  end

  depends_on "node" => :build

  # Fixes a node 6 compatibility issue
  # https://github.com/cjdelisle/cjdns/commit/9e1da7adc96b8c05cb69a6e0f5f12818502b591c
  patch do
    url "https://github.com/cjdelisle/cjdns/commit/9e1da7adc96b8c05cb69a6e0f5f12818502b591c.patch"
    sha256 "83a2bc4dfd864785a60d7c10532e0b6eeab9b0346a24f61fad6f36d7891e677a"
  end

  def install
    system "./do"
    bin.install "cjdroute"
    (pkgshare/"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
  end

  test do
    system "#{pkgshare}/test/cjdroute_test", "all"
  end
end
