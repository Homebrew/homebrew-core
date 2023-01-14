class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.16.tar.gz"
  sha256 "e301128ae6c3e257a69848bae89b5b68bb7f6e65d165a93ef6dd107079e67edd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7dc0140e44b0136c450b54c3a8b13db56431a6b17243de7ad37e381524c46035"
    sha256 cellar: :any,                 arm64_monterey: "0f84e1bf6e816ed42aaa21d31f3b288d862c93149eb1b555d70861dd3c1bfc8f"
    sha256 cellar: :any,                 arm64_big_sur:  "0b770077d5233cf5d497cc4db13544fc50592d1d6e92b318a42a905a21790c52"
    sha256 cellar: :any,                 ventura:        "7a069b2b4c05461e13e4c57789341f0460ce7cf588944bd851fb146d75e0eeec"
    sha256 cellar: :any,                 monterey:       "c2d5e46d1af9656d226c143efec29865b124575f272faae1351d7b871d518262"
    sha256 cellar: :any,                 big_sur:        "45f61f7a6c1c95e2dba2d318d10b0f6bc69ce8bf6b938f3e08078a681567379d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c03412f5482e1353b30224ef9b135e00fc7578c3e88f4bea55c50cffceb53b0"
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
