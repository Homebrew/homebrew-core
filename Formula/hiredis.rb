class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v1.0.0.tar.gz"
  sha256 "2a0b5fe5119ec973a0c1966bfc4bd7ed39dbce1cb6d749064af9121fe971936f"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b6938bbdfbc95f2fb3affb4bde281a7369b0b36cae2372f5a875edf2b67bc7f4" => :big_sur
    sha256 "447cf4bd4a60d02edd7cf1795b22dae71206bef09e6232ac6fb7de11b7c5176d" => :arm64_big_sur
    sha256 "e09527a6443e56cf0b813b7dba4d06fb483dbfb5989af127740593d04d8dd27d" => :catalina
    sha256 "076e913a91757728f99f184b99dc5ad2367d963a7cc470fc699dcfda1dea1af9" => :mojave
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
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           pkgshare/"examples/example.c", "-o", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
