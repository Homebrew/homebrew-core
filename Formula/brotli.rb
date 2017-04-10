class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v0.6.0.tar.gz"
  sha256 "69cdbdf5709051dd086a2f020f5abf9e32519eafe0ad6be820c667c3a9c9ee0f"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "4732a890dbab83f0c66e8575a8bc0b558cd8ab541f9d2684b68e5dc2c0341324" => :sierra
    sha256 "55d2f115d9b29bac587122dbf23ae748305406c5d3e8255fcdafc78077c86f24" => :el_capitan
    sha256 "1e11a1590cc842b79812a9cec13813802aaacc20d75269caae23b566b9b0e3a2" => :yosemite
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
