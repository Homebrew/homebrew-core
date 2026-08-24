class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.26.tar.gz"
  sha256 "bba03fffc5538576213675ce6968fcff6ce2e67d82e4d5febea2d05f9f13cf85"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9a46f024adee90da4cd40a8d0e3386551044c3d815406e50bc7c6ec276cdb52d"
    sha256 cellar: :any, arm64_sequoia: "f1660f8edad35044cecaa50b957048b3f2933f238c0970531db6bb5fddb09cc6"
    sha256 cellar: :any, arm64_sonoma:  "161de3d6fc46282347f8f58b17a8d57ea8fadbf920876cbe8b01d2d211244e39"
    sha256 cellar: :any, sonoma:        "7aa37f70a57483b807e6ffbbbbc1125e7c0877aea33514d39af1078e87f5b83e"
    sha256 cellar: :any, arm64_linux:   "9d83201a567ffeeaa6fd3efd16de6af17c83e5bd8c44b00ee213514622eaddbb"
    sha256 cellar: :any, x86_64_linux:  "fa40c162955d0491c534f74f4a9dd1f1606e8fca0c0e01be54c890e9985ac8a0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"foo").write "test"
    system bin/"libdeflate-gzip", "foo"
    system bin/"libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", (testpath/"foo").read
  end
end
