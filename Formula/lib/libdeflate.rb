class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.20.tar.gz"
  sha256 "ed1454166ced78913ff3809870a4005b7170a6fd30767dc478a09b96847b9c2a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25a9ae1e8167bd14f5f1bf88165f27c80caf8f5d24604579865eaf13b7a27bc1"
    sha256 cellar: :any,                 arm64_ventura:  "a97e5d8d855fd8bcd1e35a0ca2bb55bb3e05da8928ab091003c8bfd001162247"
    sha256 cellar: :any,                 arm64_monterey: "6d514e7fda8cb70c16d95147f50342fdbbf87b9706f3b9df78e3ac5eef8f324d"
    sha256 cellar: :any,                 arm64_big_sur:  "f03cc89c76225623adcee307931ae1b8f6306ae0996c9a1403091209b6743226"
    sha256 cellar: :any,                 sonoma:         "71836a9918b68414109129a7828a2e79d542d89cf05405836bcbf1dd65e77f2b"
    sha256 cellar: :any,                 ventura:        "87e07a558b1533935a4a3582948976c232ade085acb0ed39aa58736280940e93"
    sha256 cellar: :any,                 monterey:       "12d872b0cc1cfcf167a8273b555b8108c0a2ad01fbe3213fbadfa5c3a0cb3842"
    sha256 cellar: :any,                 big_sur:        "32623fc04c5e7dc31a042fc7e7029143d4a8ee77a13a9fe023dbd5038869787b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c75f2d165b9c852d2c53a4a145b3a49896c1809d23f42c20d663d7c2987c96cd"
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
