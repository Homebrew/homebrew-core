class LibpgQuery < Formula
  desc "C library for accessing the PostgreSQL parser outside of the server environment"
  homepage "https://github.com/pganalyze/libpg_query"
  url "https://github.com/pganalyze/libpg_query/archive/refs/tags/17-6.2.0.tar.gz"
  version "17-6.2.0"
  sha256 "4d5f70f23d44b6a35f1420f15b42e83b383b9db91931bdb15c9b1856800c9fa7"
  license all_of: ["BSD-3-Clause", "PostgreSQL"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70a995cd785be06bc4f2775a7bfcc89aa90dec7c0fb82e5a2543b6b427d0de08"
    sha256 cellar: :any,                 arm64_sequoia: "60aa4a1c296803ec4870adda330a4a33ddca6050961c2da9fac357e85dd99cce"
    sha256 cellar: :any,                 arm64_sonoma:  "3990de99cd90479ec619c93ae176410e70727dc5f56ff71b5ffd83522b8d67e3"
    sha256 cellar: :any,                 sonoma:        "9b6d50fefa6c25dd452215f892499892457be50e4c4508892f571ac4f502eec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a88c02c03b8682a474e40d8eba4dcc51c3c01fa7545f17d9ce7f968366e64fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5840f46f8bb0b632ff289d294543d8cc8300e9957be6417ea828003953b5c684"
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    include.install "postgres_deparse.h"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/simple.c", testpath
    system ENV.cc, "simple.c", "-o", "test", "-L#{lib}", "-lpg_query"
    assert_match "stmts", shell_output("./test")
  end
end
