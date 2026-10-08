class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "ca3180359a8b1275838a45415851f8cd5c411e27bdbf18f4823012e45507d2e4"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 2
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "929bcd0488fe39146487973d87438014b18ff1baa042a945e3599a9d236e0bb1"
    sha256 cellar: :any, arm64_tahoe:       "ba44b2e63b0c97d024a1e7eed803020d2ccea6d579c4c35f187566e9e3b23008"
    sha256 cellar: :any, arm64_sequoia:     "af42163803e4e5a1c21a8b423ba7d21d767378b24d095f843d62b92f37484ba6"
    sha256 cellar: :any, arm64_linux:       "adcbf1765cf7c53525551c9e08f02727027ad34113ec35396da8c69405a172ac"
    sha256 cellar: :any, x86_64_linux:      "07727191b4d8845310c2eba833e78b05c379c1c03cdf5504ff1c98b13897dedb"
  end

  depends_on "openssl@4"

  def install
    system "make", "install", "PREFIX=#{prefix}", "USE_SSL=1"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, pkgshare/"examples/example.c", "-o", testpath/"test",
                   "-I#{include}/hiredis", "-L#{lib}", "-lhiredis"
    assert_path_exists testpath/"test"
  end
end
