class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.20.tar.gz"
  sha256 "ed1454166ced78913ff3809870a4005b7170a6fd30767dc478a09b96847b9c2a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef4bc3719c70acff476b1089a30f5ddc04c1c8ba548a01148b6d0ecad2f265d4"
    sha256 cellar: :any,                 arm64_ventura:  "5817729d8b8bfe60f56c3eb67c4e845fe2fcf07875f83003f39ee6b0e663ce90"
    sha256 cellar: :any,                 arm64_monterey: "e02c7c600bf3ab0e0a415220c3e475b379238455f6dc7d2576147b37fdee17ce"
    sha256 cellar: :any,                 sonoma:         "c9d2b68426f8221614191519b44d12722ea9d7099830a43d71324a71d8425150"
    sha256 cellar: :any,                 ventura:        "4250f3a839c6b6b3fef9ca0a0258c1d90f471a91a005f7efc6320865c5ed0e39"
    sha256 cellar: :any,                 monterey:       "9076a50d73abd8ee01cc55c125622d97db62d64e51c32f6be2617ae60b1c66a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9570e5ed3a13f304bc21a451e420bd1ef92cebb66cc66701516bdd24fd89a334"
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
