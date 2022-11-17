class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v1.1.0.tar.gz"
  sha256 "fe6d21741ec7f3fc9df409d921f47dfc73a4d8ff64f4ac6f1d95f951bf7f53d6"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "537a403ec23a36ce04bce8f4f7f99f3ca5892cca80ac8539ef253fd4bd8f055a"
    sha256 cellar: :any,                 arm64_monterey: "a48d32622b4a44cae0a9497c5335db017695c1ba39ca0803b54fd708147053fd"
    sha256 cellar: :any,                 arm64_big_sur:  "8ff6d4e540567a736742ff46597aa566c67f1ccf723ca04b7210feabc18aa5a9"
    sha256 cellar: :any,                 ventura:        "ed4eec9bde412d7cf4d70c4f4fcd0e6067a5fc6c196015831dd7f44c093b3b7d"
    sha256 cellar: :any,                 monterey:       "70122d31f0b836cac04d879977c2e01fab184bf5de65ece1707379b40b124a08"
    sha256 cellar: :any,                 big_sur:        "c57e3c6788aaf41a8ee8331d3895de9f7c59e98a32472265ec4e1c1091e6bafd"
    sha256 cellar: :any,                 catalina:       "f08db65fcf78f259f218266fbd1cc648d7782a53e9a0cfdb39a9bb0a8ba612f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9fb9e17408007572f638756f89e15d9e53de11801d0910ad2e6e0680f5e7fad"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, pkgshare/"examples/example.c", "-o", testpath/"test",
                   "-I#{include}/hiredis", "-L#{lib}", "-lhiredis"
    assert_predicate testpath/"test", :exist?
  end
end
