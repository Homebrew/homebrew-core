class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.tar.gz"
  sha256 "08a1029d47f3b666eec9d901b2e2fe6e8f971348c10465427db95e4153ecd8b7"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "65d902b682b18871771255731e43edcc2b79d0433df84c69706760d4e3bbb4d5" => :sierra
    sha256 "9f4cb38fb83e732205dbb81a247d466d97a5b759f91fbf8b0cc65df12116fb20" => :el_capitan
    sha256 "33e2dba73aacd5fabeee29da7ba317d1c555cb0a4a48b77154db0155e234a601" => :yosemite
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
