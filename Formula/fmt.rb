class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/8.1.1.tar.gz"
  sha256 "3d794d3cf67633b34b2771eb9f073bde87e846e0d395d254df7b211ef1ec7346"
  license "MIT"
  revision 1
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6cbc489146c6c0dce9a3f9726d3a3fe4e81c5df58cfd506609244d5c22382dec"
    sha256 cellar: :any,                 arm64_big_sur:  "e1925c87f70cc2ede44a701644f78db7e914708a3298830565b431259333e498"
    sha256 cellar: :any,                 monterey:       "61b668c0df47c7c2a7dd502c85dff74389efd44f64bddf097e8859290607f2bd"
    sha256 cellar: :any,                 big_sur:        "0f63eebbc6c149acd695783eb97a104b782393778287324df962389f487d7fea"
    sha256 cellar: :any,                 catalina:       "4a9e162c919b4f81791f2b3933dc6d01d7050636de0630baee30a87a0d7a8445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c6d92ff37caff6323e45ff52d0e832b517af291f8ce70a82af1d8a0c768ee79"
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
