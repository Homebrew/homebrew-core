class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "25cee4500f359cf5cad3b51ed62059aadfc0939b05150c1f19c7e2829123631c"
  license "BSD-3-Clause"
  head "https://github.com/redis/hiredis.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a56da7fea50b3da5242b05db22d6311b0edd6f885b8793687572098d5bf02f12"
    sha256 cellar: :any,                 arm64_sequoia: "d3bb6a7fd40584c74321d404d0c459f11e3d612c329a5f95367c372cb21bbdca"
    sha256 cellar: :any,                 arm64_sonoma:  "68e9423a13a8c5dc27884296ec0ee6ab25930aaa85d3b6e5e8726855fd864211"
    sha256 cellar: :any,                 arm64_ventura: "fa65af1fbbc772155907ee6332c3a21c8780a3ce8491b762470d05cf3ae57c85"
    sha256 cellar: :any,                 sonoma:        "d7ed68aa281c0ccd51c7e28ffe6eef652478b7a03cd0e7ffd239cdd54f9412c6"
    sha256 cellar: :any,                 ventura:       "d08d4992b894522efb41ad2f502a1fa4b0e48b7a3ada25a87c7b73a03bbb6cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0760d1e33d3c044724b3c8c1053514f85a6fc12d55edfa3745cec4ed5dcf0fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0280a87a599747410042bebf2811c9c20bbe2ca577e066daa784a5ad5e1ffa31"
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
