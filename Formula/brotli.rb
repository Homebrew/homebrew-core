class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.2.tar.gz"
  sha256 "c2cf2a16646b44771a4109bb21218c8e2d952babb827796eb8a800c1f94b7422"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "6144a0ca96854448af4ff96c06a0e4aba23266f9283851e787cfa0b2a3cb2c49" => :high_sierra
    sha256 "5d2597581c6af21f4bb53f2966c3cbd7a203305a66b6697b44664326f625e0e2" => :sierra
    sha256 "d559e3e3c1b2efab8727b04d51805eccdbf5215353b5a2d0603a3d1f878854d7" => :el_capitan
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
