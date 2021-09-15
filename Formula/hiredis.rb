class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v1.0.0.tar.gz"
  sha256 "2a0b5fe5119ec973a0c1966bfc4bd7ed39dbce1cb6d749064af9121fe971936f"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "447cf4bd4a60d02edd7cf1795b22dae71206bef09e6232ac6fb7de11b7c5176d"
    sha256 cellar: :any,                 big_sur:       "b6938bbdfbc95f2fb3affb4bde281a7369b0b36cae2372f5a875edf2b67bc7f4"
    sha256 cellar: :any,                 catalina:      "e09527a6443e56cf0b813b7dba4d06fb483dbfb5989af127740593d04d8dd27d"
    sha256 cellar: :any,                 mojave:        "076e913a91757728f99f184b99dc5ad2367d963a7cc470fc699dcfda1dea1af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1250fdb113b8b8f6ebc4b07017408119db02eeb536f962df9849760b6b9862c"
  end

  # remove in next release
  patch do
    url "https://github.com/redis/hiredis/commit/8d86cb4.patch?full_index=1"
    sha256 "2f1b20defbd882c220e2c2d88da8dae970b7fbd6445363303b2ae7b75263f0ff"
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
