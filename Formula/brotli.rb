class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.2.tar.gz"
  sha256 "c2cf2a16646b44771a4109bb21218c8e2d952babb827796eb8a800c1f94b7422"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "bcb0f43337dc57d0fe955bb60644855711c7659e28260cc22d5d8773b1327fe3" => :high_sierra
    sha256 "6c883d4ae1b91389b8a3f427bce8a03c6ec75f25792455f8099c5512c849111e" => :sierra
    sha256 "9d2081d456e4fcef0cff8d961ed090543e28c4f116e204b7154aa744d1bc35a7" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/brotli", "file.txt", "file.txt.br"
    system "#{bin}/brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
