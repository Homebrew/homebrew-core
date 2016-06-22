class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v17.3.tar.gz"
  sha256 "3193df651ad9c00f31ab04feb33f801645996f6647c89b63bcc327b48e17e602"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e72d0f46337960c2adc6c1e96d08ce3a199012c6aef4a85840c2fadec153c00a" => :el_capitan
    sha256 "38c21cee07f6cb1448ce0e5caea197304f8c6a92600213c3824dcd5074b4fe82" => :yosemite
    sha256 "9ac63af21573af4a12ec07d1bbbfc253c5fead6640e596bdc7e956934cd5d187" => :mavericks
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
