class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.0.tar.gz"
  sha256 "910c1451e93a26d5825ad46ffa2510788b41db94b93593224ab7188b7abe82f1"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "cd2ed47950c14d433bc893d44e1a924b0881974932fa246c198b4668a855f059" => :sierra
    sha256 "f88a56dd54a6ce4441a3bf7e8c791a26638a2909c1ff95952748f5718b19c29d" => :el_capitan
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
