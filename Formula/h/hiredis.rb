class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "ca3180359a8b1275838a45415851f8cd5c411e27bdbf18f4823012e45507d2e4"
  license "BSD-3-Clause"
  compatibility_version 2
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "42b0b6e7412063e9f18126ed8ffbca90a00dbe6f637e91bf18e0466a0662f318"
    sha256 cellar: :any, arm64_sequoia: "744ba0aede8239ae120916df4089f6d573e7e7d10266b6a80a61c5a261021e3c"
    sha256 cellar: :any, arm64_sonoma:  "4628795741e6ccedc6bbfa17f200b5b789d6178eb21536c5aa64a40be920242a"
    sha256 cellar: :any, sonoma:        "b14620a2482fbb380412ace6d8f86a6632e359beed6ed22b5305ce0be77268b9"
    sha256 cellar: :any, arm64_linux:   "983b187e988c1b5ebdba237d73b2990c6cf025ba95ec0f8933fb470705dcb18d"
    sha256 cellar: :any, x86_64_linux:  "d6cc6c670dcb707ea52e8dddcf4208de99c111e620329ad79f76ad2adb677f10"
  end

  depends_on "openssl@3"

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
