class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.22.tar.gz"
  sha256 "7f343c7bf2ba46e774d8a632bf073235e1fd27723ef0a12a90f8947b7fe851d6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb6e2d1eb27e02b14541f965fb81f8bfd98852e8db7729540e135c2a356ab4fb"
    sha256 cellar: :any,                 arm64_sonoma:  "d0855ef6b2947b130aae38dc3f7e758c450b03dfcd4e923669b573d4aeefede1"
    sha256 cellar: :any,                 arm64_ventura: "ad4a626589cb82f253cf065aef92ea5dc77f51bb80cbbf66558a212cd88665ac"
    sha256 cellar: :any,                 sonoma:        "34c07181913c15251daa7dcf9801d29f1bb7abfb6719ea6c98054e48e25dcebb"
    sha256 cellar: :any,                 ventura:       "d0fb44f38bffe30a903f94c28a4097e5b6a034af7d676931b351cac801aa985b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4014531967553e8f002d52585698b5f2cdc689e1359563145ec3723c7ddc490b"
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
