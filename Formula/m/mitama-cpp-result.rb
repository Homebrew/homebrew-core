class MitamaCppResult < Formula
  desc "Provides `result<T, E>` and `maybe<T>` and monadic functions for them"
  homepage "https://github.com/loliGothicK/mitama-cpp-result"
  url "https://github.com/loliGothicK/mitama-cpp-result/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "fdfe81098660e7365e79760616231eefdd42dd7760970c0e7ea4c6bacce46440"
  license "MIT"
  head "https://github.com/loliGothicK/mitama-cpp-result.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28440190e9a47c233c1ad311a8adb5d4ecee78b57ee8b790c35a12ae27110419"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :test

  def install
    # We don't need to do `cmake --build` since this is header-only.
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example.cpp").write <<~CPP
      #include <mitama/result/result.hpp>
      #include <string>
      #include <cassert>
      using namespace mitama;

      int main() {
          int i = 1;
          mut_result<int&, std::string&> res = success(i);
          res.unwrap() = 2; // get reference to `i`, and assign `2`.

          assert(i == 2);
          return 0;
      }
    CPP

    fmt = Formula["fmt"]
    system ENV.cxx, "-std=c++20",
                    "-I#{fmt.opt_include}", "-I#{include}",
                    "example.cpp", "-o", "example",
                    "-L#{fmt.opt_lib}", "-lfmt"
    system "./example"
  end
end
