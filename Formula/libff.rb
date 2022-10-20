class Libff < Formula
  desc "C++ library for Finite Fields and Elliptic Curves"
  homepage "https://github.com/scipr-lab/libff"
  # pull from git tag to get submodules
  url "https://github.com/scipr-lab/libff.git",
      tag:      "v0.2.1",
      revision: "5835b8c59d4029249645cf551f417608c48f2770"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3bc7fe57f5d06f468d143100f64767344d54cf8f925b41ad72431828807b8ebd"
    sha256 cellar: :any,                 arm64_big_sur:  "de8ad0e6ec68dd26c530f29e4e3d20247d2d4488e3355b53f036168eba942544"
    sha256 cellar: :any,                 monterey:       "01a39f20109229d722f510d67183de70611fa206e8c2407c878cf63ad03b9bfa"
    sha256 cellar: :any,                 big_sur:        "31327452c277cb5ab2b8c466ec66de12bf8839657e7a3e45faafe88f38c8ddc8"
    sha256 cellar: :any,                 catalina:       "cfa9fac08910ff673c989d63a79076a33e063d15702a4b733098f151e3cf86f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "587d6b29ca7e2570567f0f1bc6660143d910b69262011c2d2c1021ee1fba8194"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1" => :build

  depends_on "gmp"

  def install
    # bn128 is somewhat faster, but requires an x86_64 CPU
    curve = Hardware::CPU.intel? ? "BN128" : "ALT_BN128"

    # build libff dynamically. The project only builds statically by default
    inreplace "libff/CMakeLists.txt", "STATIC", "SHARED"

    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_PROCPS=OFF",
                    "-DCURVE=#{curve}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libff/algebra/curves/edwards/edwards_pp.hpp>

      using namespace libff;

      int main(int argc, char *argv[]) {
        edwards_pp::init_public_params();
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lff", "-o", "test"
    system "./test"
  end
end
