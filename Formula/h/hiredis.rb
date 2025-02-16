class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git", branch: "master"

  stable do
    url "https://github.com/redis/hiredis/archive/refs/tags/v1.2.0.tar.gz"
    sha256 "82ad632d31ee05da13b537c124f819eb88e18851d9cb0c30ae0552084811588c"

    # Makefile: correctly handle version suffixes on macOS
    # Remove with `stable` block on next release.
    patch do
      url "https://github.com/redis/hiredis/commit/77bcc73ebbc562d8e8173832b710bfbfa4327b13.patch?full_index=1"
      sha256 "1f6d2266b258f32da36a9f2ce9c03d492920e13444925cf01fe0cb4cde1d6e2c"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "4e524056481b35899b3faa28ac1ae3f4f716ad3c5b714ec9daf9ae6657e48823"
    sha256 cellar: :any,                 arm64_sonoma:  "ed340b77f0d20b01316f004565559d8d50d275aa1ccbd08e5d14427a0de5ca2b"
    sha256 cellar: :any,                 arm64_ventura: "5ad4bd7bb1d271bc70336abb292491952d11ac567165bbff27675a2aedee4c7e"
    sha256 cellar: :any,                 sonoma:        "1e6b61f4ffd1cf76ce8e87e4444f4bfad88aa64baa87d31667b8f84845a46583"
    sha256 cellar: :any,                 ventura:       "d1dfee9546fdcc55d414bb4998ddcc72338cebfbd806fbd9e9d74fb6cb96b818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb485ff3050d1ca96db614b96ec92b9595249f967e1d5851acc1633324780d4"
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
