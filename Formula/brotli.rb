class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v0.5.2.tar.gz"
  sha256 "2b7b1183682a17d8a9b83170fccdbec270c9e56baf8c0082f5d9c4528412d343"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87340dee935befbe7725299c179701aea8329fdccaf060abb80af5ec4cc1aa3e" => :el_capitan
    sha256 "cb53aec45fd5914c01ab1bdb80395e87b69ed4e70a3fdc3f3fdd09ef4c69be46" => :yosemite
    sha256 "6bef71245c4fc886a3df778e3ecd0c9173e4a432a9e880ce3dac3442a891094e" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "bro", :because => "Both install a `bro` binary"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/bro", "--input", "file.txt", "--output", "file.txt.br"
    system "#{bin}/bro", "--input", "file.txt.br", "--output", "out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
