class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/v0.0.33.tar.gz", using: :homebrew_curl
  sha256 "49375521e48daa09c03e2bfabb18ca35f7e142abdc35bc5d0144c72aef513efb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "746de5336fc3c2c7f2e401a1f87e7807b68319a014e097c1371c6999202ee195"
    sha256 cellar: :any,                 arm64_big_sur:  "580151279a789ff27f5dd2aa6c3c3798675c4abb3c96e4200953a9e765da40d6"
    sha256 cellar: :any,                 monterey:       "05bcb2c85066e5bfbfb251bb29997fdf271546cd4a2f5db9ffb5c5f2ec0d0a57"
    sha256 cellar: :any,                 big_sur:        "9c2bf0d877d336b86b3992185aa4f497ddfa511b37888aaaedde8f176dfb26f4"
    sha256 cellar: :any,                 catalina:       "6bda1ce4a4cc6e9d0511123af46f84fc08f6986549acf42d04ba1cafa796e3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd429ecd1bbec172f8b09d53e6986c8d90dc2e8fa54a1ab9c98b63b9178eea88"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", *std_cmake_args, "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
