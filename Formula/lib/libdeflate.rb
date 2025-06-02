class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.24.tar.gz"
  sha256 "ad8d3723d0065c4723ab738be9723f2ff1cb0f1571e8bfcf0301ff9661f475e8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "187850054c03e9417b2234ab30efa87b93a029b31e28fcb95b169579217ad333"
    sha256 cellar: :any,                 arm64_sonoma:  "b0672b22ba14406d032136734bb5852125bbe61c651253a3ed1820d7196557a2"
    sha256 cellar: :any,                 arm64_ventura: "66411c4bcde1c756aaa09c46dd3e70e3b3992843efd5c795c23b0750a2f58002"
    sha256 cellar: :any,                 sonoma:        "2e7067afa9095766f5ea81162c05028e50d433bd334162874974598841fb9415"
    sha256 cellar: :any,                 ventura:       "879ece3dc6bbe8171520d17bb94f234df0a0eed235c99397ff053d8596ecd20a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "552ea942fcb9f35324efe30f6465f1938987c80d9a391c34b22f3e81a1191a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "784b1c1d1259c7b078883e0e14aabed1df975bf4eb483faea843cf2526032020"
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
