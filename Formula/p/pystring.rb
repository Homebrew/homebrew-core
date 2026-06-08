class Pystring < Formula
  desc "Collection of C++ functions for the interface of Python's string class methods"
  homepage "https://github.com/imageworks/pystring"
  url "https://github.com/imageworks/pystring/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "63c30c251b8017c897bd923826f400aee1d6e4f1c22ffbbd2104f150522a2040"
  license "BSD-3-Clause"
  head "https://github.com/imageworks/pystring.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8551e6f8746e71fcee64d4ed87bca6d2c36886a1f4e245cb43dc08a650ca3079"
    sha256 cellar: :any,                 arm64_sequoia: "af49426e6d2d783b19bf9699a5941260b55f22fac04655e8093ac40bae0d8b04"
    sha256 cellar: :any,                 arm64_sonoma:  "531f63ad88b34de8b36c3393aac6c7bb110285d53a72933c837dcaab580fa97a"
    sha256 cellar: :any,                 sonoma:        "be6c46e4fb10684eaba28454ca699d034a217ce8f7f94dcc48e764c001be751f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d43bb1fabf32b855220881055ede17ed2541037b31ef4212e134c88b19f4ea2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "884db0f8d1d046ffb96bd65987f762e2da57b19426bd01ec403fa941d0075325"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install "pystring.h"
    pkgshare.install "test.cpp", "unittest.h"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"test.cpp", "-I#{include}", "-I#{pkgshare}", "-L#{lib}",
                    "-lpystring", "-o", "test"
    system "./test"
  end
end
