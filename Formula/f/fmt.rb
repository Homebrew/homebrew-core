class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/12.1.0/fmt-12.1.0.zip"
  sha256 "695fd197fa5aff8fc67b5f2bbc110490a875cdf7a41686ac8512fb480fa8ada7"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "008ec3a1b84d5db3334383279f6aaf1da457a1173efb14e9bd1d41beb7f6d6da"
    sha256 cellar: :any,                 arm64_sequoia: "18312bbc96d1074563572481084b3db66e35119b8f76b321f37a74d6a9d46b46"
    sha256 cellar: :any,                 arm64_sonoma:  "ee29782046b7c86462e2a0cef189868a5a861c7d2b5989923da0499de3698ee6"
    sha256 cellar: :any,                 sonoma:        "dedd10167d4ad5aa173d40ed13a19e1648db680fb0569114caffe822bad14554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84463daea1c23f94ae58abbf951987bea488c0161be4d9cbc785594d88f02d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c4de1f40ac72b6f014ee7690e9a005b6689d270d6ace076719de7484c7d85b"
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
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
