class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/frameworks/ktexttemplate/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.18/ktexttemplate-6.18.0.tar.xz"
  sha256 "cbb6505c35a8edc0e6fefb7d24fde8275eefdc9735407297ace02a7c40f37e06"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "b950e5481b23df6c39b8b0e53adf53ba49041e3c86c434c18c907de403819d5a"
    sha256 arm64_sequoia: "5b8aca184bb27d42c4f2cd150cced5606b0ebfd5a5e74d5e251a0046ee62b2fb"
    sha256 arm64_sonoma:  "c9af0dee6f95c631641ab432f7245eada352a6adf78eb08a9493c95d25bdba59"
    sha256 sonoma:        "f758f5606981561634a528ead15804398712bbe7b00635a7ff3733579867b5f1"
    sha256 x86_64_linux:  "01786cb89bf22138e2528989345381afe90bd33df87521aa9ca0165dff334b59"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system "cmake", pkgshare/"examples/codegen", *std_cmake_args
    system "cmake", "--build", "."
  end
end
