class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.21.tar.gz"
  sha256 "50827d312c0413fbd41b0628590cd54d9ad7ebf88360cba7c0e70027942dbd01"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fea1730f71dee848ea635ebbf03ce45563d784e3ac51b1c49feedb8859e6d220"
    sha256 cellar: :any,                 arm64_ventura:  "2391e55f34424f2fbf2d2c0c722ab5f26d0b2ef19b29298e9765078347be8121"
    sha256 cellar: :any,                 arm64_monterey: "34a7a65a65e10326a3452c041d195306907ea6b20881c4e2b5484597730808ec"
    sha256 cellar: :any,                 sonoma:         "abc65ab8eca7ddf0fcdce501d6127a626272c0f5dad13165d1f3f17d91c9a894"
    sha256 cellar: :any,                 ventura:        "b488d5379e40d17416ee8f3d845916d564f18c7be8672e1529e0955d634f1b22"
    sha256 cellar: :any,                 monterey:       "c6071f321bfb1639a070e1645dbf8ca78ee963cf989f9e200fc874cba5daf4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b6d0895f05a0ce647e5c1bfa96fda7bb543461e49b84bcf9e60586a31b6c311"
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
