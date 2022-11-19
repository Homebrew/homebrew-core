class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.14.tar.gz"
  sha256 "89e7df898c37c3427b0f39aadcf733731321a278771d20fc553f92da8d4808ac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e5ee2ffedd51e64581e9bf9bdcc99ef750f7749310584b08a2192cf31b63874b"
    sha256 cellar: :any,                 arm64_monterey: "324ee7719635c163f1d5fb751a577cf58c0798990982284a047ad8009605bd98"
    sha256 cellar: :any,                 arm64_big_sur:  "58846f6a35bb709a379aaa0935a3cba7c2a1152496c0ffb3faa92b3e0dcdf684"
    sha256 cellar: :any,                 ventura:        "b4dadf1d9a1f74a83ece22380554b9512d7a491384cbd5e995cb555364e1426a"
    sha256 cellar: :any,                 monterey:       "28b420821d6358bf36e4f8be76774bddb04a20b2167f866204df77d12c78680e"
    sha256 cellar: :any,                 big_sur:        "7c28cefed63f6a4c68c8a923665b4450ea672ca3b83b80bb4a08f3b27e21e0c9"
    sha256 cellar: :any,                 catalina:       "d0c47d6630933b8c68d2c2c94bd8be47c942f9a96c149e0bb8ddd81cb9e04edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef64ef6bc47bce68ba644f57f598dfbae1b0112ddf477c02facf691ef4dfb8c"
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
