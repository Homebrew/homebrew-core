class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v17.4.tar.gz"
  sha256 "2f30aa4d2cc96a6c1f00e873df19b7b213cca1af716d74a091f59aa98b5758c4"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e72d0f46337960c2adc6c1e96d08ce3a199012c6aef4a85840c2fadec153c00a" => :el_capitan
    sha256 "38c21cee07f6cb1448ce0e5caea197304f8c6a92600213c3824dcd5074b4fe82" => :yosemite
    sha256 "9ac63af21573af4a12ec07d1bbbfc253c5fead6640e596bdc7e956934cd5d187" => :mavericks
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
