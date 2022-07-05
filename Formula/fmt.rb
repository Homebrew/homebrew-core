class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/9.0.0.tar.gz"
  sha256 "9a1e0e9e843a356d65c7604e2c8bf9402b50fe294c355de0095ebd42fb9bd2c5"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "47866137bfcc88428ad11fb6b1a6815a3e23343a01b87532921f9606c8079df0"
    sha256 cellar: :any,                 arm64_big_sur:  "9e6672c625f0a4ef5f493d0354d61cb37544c3462393050515dfda94e8cea3d7"
    sha256 cellar: :any,                 monterey:       "adc6bcafd5a51853ee1263c965780e22562f0ac551c59776f2ed3271eb91e2d5"
    sha256 cellar: :any,                 big_sur:        "e704728001d94f2b8a25656ae8f06099c1f6ca4b36a26a5b05f2946226a62077"
    sha256 cellar: :any,                 catalina:       "ec6ed03041add5859c98d14a604b9dbbc78f33b5c30bc1bd462560523970a4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ce6065175c67d5fbba475c74b1efce928566d9df76dc7bb51e9baa1f3a3c6b2"
  end

  depends_on "cmake" => :build

  # Fix Watchman build.
  # https://github.com/fmtlib/fmt/issues/2717
  patch do
    url "https://github.com/fmtlib/fmt/commit/8f8a1a02d5c5cb967d240feee3ffac00d66f22a2.patch?full_index=1"
    sha256 "ac5d7a8f9eabd40e34f21b1e0034fbc4147008f13b7bf2314131239fb3a7bdab"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "make"
    lib.install "libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
