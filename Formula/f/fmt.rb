class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/11.0.2/fmt-11.0.2.zip"
  sha256 "40fc58bebcf38c759e11a7bd8fdc163507d2423ef5058bba7f26280c5b9c5465"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0960a214392fc344670c2fae5a698799c910743d437c0119756cab9c5395bbd2"
    sha256 cellar: :any,                 arm64_sonoma:   "244d2f9285c080d0dbef74e2741082754a82d13bf0c1da25130dbbc82d648162"
    sha256 cellar: :any,                 arm64_ventura:  "13febc98177289f86421181ee4eed45b8d47f88ae4ceb573c4106af2db355bf7"
    sha256 cellar: :any,                 arm64_monterey: "cfdbcf9079cfe3ec3148408799bdf73f1f8a8ec55e85576ba6884383a756423d"
    sha256 cellar: :any,                 sonoma:         "3cfdbc8234181a472bfaa81699f68745c741a3f12d394da25926a8c11f2fbc20"
    sha256 cellar: :any,                 ventura:        "9c1f360c5996c6bc94ce7fd06871fc02016207ae671c4649a28cc163ef8b057b"
    sha256 cellar: :any,                 monterey:       "656e4cdeba06ddc3b4f7e3b375177217595e4f23f26177f77bb486d117e6fe0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f0d3d18a30bdce1b31b873722c5cb369f8ad7dda2c4e9b258d489a5bc9102e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libfmt.a"
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
