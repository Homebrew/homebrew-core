class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v21.1.tar.gz"
  sha256 "a6158ce7847159aa44e86f74ccc7b6ded6910a230ed8f3830db53cda5838f0b0"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13c629ad726315a5e7e664f45c89cac07c48491791216e312bc259ed9b42803c" => :big_sur
    sha256 "b40905920fb755137bd4ebb409a92b9472419e974eb634834de0cf4f8ee4b39d" => :catalina
    sha256 "badca34b50dc0c5eb97d22d1538e8b12cf80d8d28acdeb31fd00ac4fd9074e12" => :mojave
    sha256 "a3708d0844e30cc69de62232117b683ac8f48426f9c8a12781fcd042c581b0e5" => :high_sierra
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
