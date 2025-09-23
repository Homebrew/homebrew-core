class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/refs/tags/v1.21.6.tar.gz"
  sha256 "9fcd60301aae28f97f1301b735f966cc19e7c49b6b4321b839b4579a0c156f38"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0e7738316917ed92787b41bf1c0a7445edf167d5928249342ab9caadb4fe08a6"
    sha256 cellar: :any,                 arm64_sequoia:  "2e382c2fc65f79ed2a7a71a30c625af2187aaca91132643af2087039a50736c6"
    sha256 cellar: :any,                 arm64_sonoma:   "7f9fa549976087279fb6135f6b068ef6a92eb7a76937b229e253dc0e7324a344"
    sha256 cellar: :any,                 arm64_ventura:  "deae8256b46bfb5973bcb30321c2e5e28a86e733ce074d3395d75f797d65126e"
    sha256 cellar: :any,                 arm64_monterey: "2ab5b72ffe025c978945c4225be4eab02b012b82280dd59e88654a1d889964d7"
    sha256 cellar: :any,                 sonoma:         "f6837382559667940cba3903168bfaeff2bafbca5d39c41ca7586507f6e2623c"
    sha256 cellar: :any,                 ventura:        "ac3f9f476b9f5f72123b945f1f67aadad959762f55fb1179eaa3471208da5c27"
    sha256 cellar: :any,                 monterey:       "39017af35970c5dcbdc33dacdd2673bff743593aaa26a68a2328c8bb3e623dbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "866cec70c5ebbb92e7115481a9aa3de619f6425c6539b1c446b83ec0b3326c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945cb54d12083813c6ef5c7a4dcaf747fbfd8db3dd37e8c4d3f69150354d69ae"
  end

  depends_on "cmake" => :build

  # Update minimal cmake version
  # Remove on next release.
  patch do
    url "https://github.com/Blosc/c-blosc/commit/051b9d2cb9437e375dead8574f66d80ebce47bee.patch?full_index=1"
    sha256 "756460f653877c12575889f20640605ecc2e49ab72583fba62f59642098fcd63"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
