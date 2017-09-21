class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.0.tar.gz"
  sha256 "910c1451e93a26d5825ad46ffa2510788b41db94b93593224ab7188b7abe82f1"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "4c66b87fea8c54419bb55f9f93bed226ca6510af736cebd316efbe8ecc278378" => :high_sierra
    sha256 "4732a890dbab83f0c66e8575a8bc0b558cd8ab541f9d2684b68e5dc2c0341324" => :sierra
    sha256 "55d2f115d9b29bac587122dbf23ae748305406c5d3e8255fcdafc78077c86f24" => :el_capitan
    sha256 "1e11a1590cc842b79812a9cec13813802aaacc20d75269caae23b566b9b0e3a2" => :yosemite
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
