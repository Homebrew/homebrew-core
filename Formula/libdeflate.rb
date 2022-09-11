class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.14.tar.gz"
  sha256 "89e7df898c37c3427b0f39aadcf733731321a278771d20fc553f92da8d4808ac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2505ad444350caeef3571cbb15ff094cd3ed6dfa7292a3ac4631e6fd2b3efc36"
    sha256 cellar: :any,                 arm64_big_sur:  "e506e8ceb08bdcc9631b875140d0e05f792d64632233903cd227e73ce8626669"
    sha256 cellar: :any,                 monterey:       "81435b0f79379462ffde79e20664a6577e37b1ef0ec08e8556360174d2b363bc"
    sha256 cellar: :any,                 big_sur:        "bed0f0ec552f57c28bbd23f7eedfaaf12d2d34e22d086fbf4aebed3d214b4a26"
    sha256 cellar: :any,                 catalina:       "dc5405218841b06f5709b032c828a4bfd9d86ea2c8119e3878cea8a5b86288ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8545e17892476f0f3d1f2ff043f081476496677917af79e3d38cf6421fac6c"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
