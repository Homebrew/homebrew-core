class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.4.tar.gz"
  sha256 "e72bd03827b8564bbb3dc3ea0d0e689b4863871ce3861d946f2efd7a186ecf3e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d52d939fe29c501914e3cea415756a0324a73157e16023dc2c148aa665c17bb9"
    sha256 cellar: :any,                 arm64_monterey: "8f5cd6d0670a21cab38df355c6f183f6fc77cfb7bb520fa70edba3fffd59e97f"
    sha256 cellar: :any,                 arm64_big_sur:  "bbc66d7eacd592fadebb395a618953decd34fe1c94bb4822673e235f41457d52"
    sha256 cellar: :any,                 ventura:        "9a1b53bd64a02c249500e9741ed2648550a2240af0681907bcf68c530f14ab1f"
    sha256 cellar: :any,                 monterey:       "0f2e66f12f4b8c5b49460f80fe6dac397cf463a325daa33d1567882e5a0a8087"
    sha256 cellar: :any,                 big_sur:        "5ec8b99afbd659312223f83e6b739d226e7df87403f24e1e79a8e6ebee3e5cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "807513351705aafc65cae1be6a6d455d25c6a03e261df98bca14bc1e012db5c7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
