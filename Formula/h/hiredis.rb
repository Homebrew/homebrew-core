class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "25cee4500f359cf5cad3b51ed62059aadfc0939b05150c1f19c7e2829123631c"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/redis/hiredis.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74eb2e4780a211d5a29d9695b455ce7dbcc72f1d800db208c7cfcd22577e5667"
    sha256 cellar: :any,                 arm64_sequoia: "74568195832c3e0f6df78f7d8cc20b0b26c00ccdac7d21f26b92a672e50b7969"
    sha256 cellar: :any,                 arm64_sonoma:  "771c9ddf9487b9ca90736deb3d0c7e6d60ab17195d4539aaba1590c108c1c6f4"
    sha256 cellar: :any,                 sonoma:        "868c742fc2016692f1f7f1842f10d0b0d7505684d53a03053c84911f5c9071da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4468062dfe9d64cef30ed32b69a33b17bdf62ba1030cd66a84291009c50d1e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c948abd177e9d17ff1f3d7ca8cfb4f90c924f8ab02cde18e18dfa7ea1886a1"
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
