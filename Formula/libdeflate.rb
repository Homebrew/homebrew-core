class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.17.tar.gz"
  sha256 "fa4615af671513fa2a53dc2e7a89ff502792e2bdfc046869ef35160fcc373763"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b98671ff235b4fe5bb24a629dac6670bc6f956c428ae3f937b4f5c27d7057ded"
    sha256 cellar: :any,                 arm64_monterey: "c6639c5fcad776b90a62da4e353e577b897f80351d88ed6f6c3a5967934390e7"
    sha256 cellar: :any,                 arm64_big_sur:  "dd0fcf07a1d6b3db2a48097b242473124e588254ebbd07194a59dccfd198edef"
    sha256 cellar: :any,                 ventura:        "63183c7b70116984620c194e7a652d9ba6bf4e2c4fb9d33f2d93ad1aef4ce296"
    sha256 cellar: :any,                 monterey:       "157a4cbf52a7eefb91331588875656055a1d049465ca752fbdf4ad364c9b8ea6"
    sha256 cellar: :any,                 big_sur:        "2174f1098c88a0257dd216fd275a0ebd4a0a3333f44f0017dae76b7fef6e152d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e95678b4c32c0bd6169047245a85aa4fceaca665de00dfcffd09811c8efc6c7"
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
