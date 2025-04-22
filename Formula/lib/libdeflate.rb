class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.23.tar.gz"
  sha256 "1ab18349b9fb0ce8a0ca4116bded725be7dcbfa709e19f6f983d99df1fb8b25f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a70dfdf41b38cacf0886866614b2e1fa1187cf45cfa34b05442fa129471b1cd"
    sha256 cellar: :any,                 arm64_sonoma:  "15e665a6443b3f652cb920892a936cf09af93fb518c2771fde48211f3cb81a11"
    sha256 cellar: :any,                 arm64_ventura: "163a29ded43e4a43301b2293f791046149afed398d3d25db99606c1a72747db5"
    sha256 cellar: :any,                 sonoma:        "c623df6939889263cdaa4467ab95f63f911bfc2bed786b1a27733b0c055ae9cc"
    sha256 cellar: :any,                 ventura:       "29c4f0b40032c3d9e95c6e2994369da30a8b3f90b2dd91529eac78c8bde952a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f3b95044b4ac10dd047f01ffd8e9b5ec6661950ac5348eee5a18e4e33550ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ff89c9b3782110b6b0d3f6c99398ada2780ce3a3d98b50ec2fa6e2d2c7c82e"
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
