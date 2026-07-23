class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "5fa6e719e59cd4f8ae435c52a18ac4035d135251f9ee54e7a045bccf59107ed8"
  license "BSD-3-Clause"
  compatibility_version 2
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6b790b72b583f7b80fb6fa10477286fc24f58e05b15f814fda74c77fb1dcb139"
    sha256 cellar: :any, arm64_sequoia: "77068c6a45f408fd3f9fa56d6253a157f2e961be310c502ce4095fbdb6ca0de3"
    sha256 cellar: :any, arm64_sonoma:  "c1594add8d86832e003d0e4ecca2aea251fe06f0fe09f29d87ca352b8084bac7"
    sha256 cellar: :any, sonoma:        "a6a7bc59e6a82b54671376725bdfe06fa77181c2aba9715e47930811883c8a9c"
    sha256 cellar: :any, arm64_linux:   "8514ba4a07e070151d9b15399398125ddc33ea2a3e6a214de005af458fc33cea"
    sha256 cellar: :any, x86_64_linux:  "b41adf32ce488a7cf126674175993c7ea9f19c9f4c1d6fc168bde86c6c12c337"
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
