class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/refs/tags/20240000.3.tar.gz"
  sha256 "43d086dc06d11c20409da688ecdc312a061d504b425a1a3871a0a174a86a61a2"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "12ae2bbd836e116f8e608333bc7af3a1dbfeee17942a15005b2c6c3f81d64745"
    sha256 cellar: :any,                 arm64_ventura:  "4cf257fb4bd5154e68f01257cce38fc216c57961695cbbd636e36255a5b97b7f"
    sha256 cellar: :any,                 arm64_monterey: "9ac44e35e95b0431963b44da9fe4042f78ff8712aa6115f09ee511cecd23c7eb"
    sha256 cellar: :any,                 sonoma:         "838b0387119ee362941af56b7445ab09763cfa8eb4601af6dc0e38f5ae6bedb6"
    sha256 cellar: :any,                 ventura:        "942da8efe1194e69d061ff8014a0ebcc8a684557d332ded003a146d82fe2bb19"
    sha256 cellar: :any,                 monterey:       "ef0b678341ad3d04ce90a9bd555a2dcc4a9523a5c62925524d542e49d2ba33f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99e3a19bf3affc19bf27c1cb433d1b4ddf075156fb8392797ed02a0f5710445"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-Dcppad_prefix=#{prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/local/temp_file.hpp>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
