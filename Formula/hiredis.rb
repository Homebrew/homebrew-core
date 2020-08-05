class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v1.0.0.tar.gz"
  sha256 "2a0b5fe5119ec973a0c1966bfc4bd7ed39dbce1cb6d749064af9121fe971936f"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    sha256 "4b089bee868b4fe533bea75917f21a42a11a9e04d5b396ec5a94d5623372ec0b" => :catalina
    sha256 "8974f8bacac7ce018f6f238915c6c5f07751c5183283337634a1715624d344b8" => :mojave
    sha256 "5ed94f51e6dbe91f7d195be5a5d085c7929f82bafeecba8645dd2315a94dad8d" => :high_sierra
  end

  # remove in next release
  patch do
    url "https://github.com/redis/hiredis/commit/8d86cb4.diff?full_index=1"
    sha256 "844c6ff68b403ad5b4003c96709016c3e498a156c61a1228928bf3e2f407fa73"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           pkgshare/"examples/example.c", "-o", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
