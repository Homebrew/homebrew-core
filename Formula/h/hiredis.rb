class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "f5ec19151c0f4f15ca018c22b17b6f6739a672a4fc0c085b692aef69a154ebef"
  license "BSD-3-Clause"
  compatibility_version 3
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    manifest_sha256 "900d112b5c7eddb3573c24d46b4b4065e1c566d2e531a2edb22eae8e7413af75"
    sha256 cellar: :any, arm64_golden_gate: "3909d04c4db1e84ad6c0365d6748efe2d2d42a76c4bca41893c829e5bcbe1d07"
    sha256 cellar: :any, arm64_tahoe:       "512e5b2b7330fdb6973d23b3ea528eac2c422a1b94ead8210d8b0e2805d390ab"
    sha256 cellar: :any, arm64_sequoia:     "e198c1c0d5ac924a42f189ba584b79de70dcf29574d6063eface75b12fb4b2a0"
    sha256 cellar: :any, arm64_linux:       "4a8352eb9f232532be77171f1019e70df5a63bf15f9ac1b1ed100afdc68f8736"
    sha256 cellar: :any, x86_64_linux:      "089c198d7878c28c91a396b44b577da3735c01ee4f2a6972c7c72b38f1b59388"
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
