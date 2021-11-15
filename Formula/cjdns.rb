class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v21.1.tar.gz"
  sha256 "a6158ce7847159aa44e86f74ccc7b6ded6910a230ed8f3830db53cda5838f0b0"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "5ba943bc0a44c52c2f23bae683e9fb28b7d1c11e76e5c6cfe7d97f5fbc65c1b1"
    sha256 cellar: :any_skip_relocation, big_sur:  "b57d1c38866eab0c671732fdf70890fde76e7b03a2fc6a3dc59d5dea29e9fbaa"
    sha256 cellar: :any_skip_relocation, catalina: "dc8c73f740f3bfbde7db45dde12cbc57bc34c925b88a15be55e4ba47b73eb1d4"
    sha256 cellar: :any_skip_relocation, mojave:   "6f5536caa2f432a96027fa223e20b12d54baa78f96a7d5cabb454ad380faf523"
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
