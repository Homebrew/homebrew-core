class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.6.tar.gz"
  sha256 "ce94b7f48af5e8f444c3949ca93201c1b4bb40da633db084e900133ce87848db"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "b36480b61ed76a27e4be389cf0a99c9fbba4e7d2ce762a37a2ee80042999e506" => :mojave
    sha256 "4bee5587f4ce589b094165c33696274da19042b9ac1e1f738a69e72f54f5f6c8" => :high_sierra
    sha256 "471b22b887f5156d6aff56752d939840db1d2362c4fe3773783ca49b5db05802" => :sierra
    sha256 "b32ea035cb9d1eae9e7895ffd3909ab2d3ca8391aeae47f3772fc71686d2713e" => :el_capitan
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
