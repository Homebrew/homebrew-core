class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.18.tar.gz"
  sha256 "225d982bcaf553221c76726358d2ea139bb34913180b20823c782cede060affd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b2e112627f0d3d96bdcc963325d8adaa25b3a0f9fd496fb16c9e90bee89075c"
    sha256 cellar: :any,                 arm64_monterey: "6033e7914e305fdf6a89beb659d7b13d142c22b120cadd58818e716894d8d3ad"
    sha256 cellar: :any,                 arm64_big_sur:  "8ca091cea4f792ecccc9b1a04b5aa191069be84275026d8f558a0bf83d9de4c7"
    sha256 cellar: :any,                 ventura:        "04afdbb6ce553f2fcb8d1c592dab0ae5d72c43a4aa0f9d0701548033e5512ff7"
    sha256 cellar: :any,                 monterey:       "b1cfd87672ba2ea5b73e1d9e63394eadab5e0534d6024094a866575867319deb"
    sha256 cellar: :any,                 big_sur:        "23aed6083b2e468777c4815297c9a1ef22a2cb04d827812f62b6feef8707405f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5321d573c497dddbac53530c2fffb3e15a4fd0f31bee3976bec294dd4004949"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", File.read(testpath/"foo")
  end
end
