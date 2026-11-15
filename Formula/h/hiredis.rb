class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "eec7ef8641d221e144a58d5ef8d733c8c75c7fd487097a233aacb4fa33981cfb"
  license "BSD-3-Clause"
  compatibility_version 3
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "70dc4f93a1e7ce548f3f9d487c9a4539b2bfcfcca22eade6f4cb754c1e99115c"
    sha256 cellar: :any, arm64_tahoe:       "4f115a7323562c3735e80a6c1a62cc6522e91785617d72f4dee91567420b117b"
    sha256 cellar: :any, arm64_sequoia:     "7b801854e2b89bfa18c64c248046c5e375779b580f636ef75f0292f156a243b0"
    sha256 cellar: :any, arm64_linux:       "b1dfbf2cc69908e2d2efc57991c1b686a49552671217fcac1e022dec19b3017b"
    sha256 cellar: :any, x86_64_linux:      "d21308c1a1b77a4656159bbbe0e7c4b4a3ee7f4764edf5f1769da6ffaa267dda"
  end

  depends_on "openssl@4"

  deny_network_access!

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
