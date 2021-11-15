class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/v3.1.0.tar.gz"
  sha256 "d3234d7f94cea4389e3ca70619b82e8fb4c2f33bb3a070799f1e18eef500a083"
  license "MIT"
  head "https://github.com/Microsoft/GSL.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1fe9e903b18a03aa61226caafb7109b2c7f638b0e4d510c64c4911b2566b855a"
    sha256 cellar: :any_skip_relocation, big_sur:       "f635cfb0498a07174dd4dd06dcaeeb4f461508d0cffc622dad19258a472a8691"
    sha256 cellar: :any_skip_relocation, catalina:      "ba5b32881db75527872525bcde6bef641bdb6c89dff511ccf5105229f1ba1e7c"
    sha256 cellar: :any_skip_relocation, mojave:        "262709d81631cc7aa7477b03bd1904320da93b12cecf4aded01e3cc59917287f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "262709d81631cc7aa7477b03bd1904320da93b12cecf4aded01e3cc59917287f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3caa95f07cbba5c285cdecdfedb44c7768a9f4d99258ad5c1b16b12fa040ef3"
    sha256 cellar: :any_skip_relocation, all:           "6a97d947f9aaea4dbadef6dd56ea5454918c0ce2306c3351bdd9265a6eda7ea8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DGSL_TEST=false", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
