class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.29/ktexttemplate-6.29.0.tar.xz"
  sha256 "6ca3b4be8a76fff109297a5c6b1d23f5d55fa4b4110575d4c3287ee8b10619a9"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "54097972a8db1f98fdc1754321a5f9e910bfc56a3de56021e30d254f17e933e4"
    sha256 arm64_sequoia: "7a3656b638e1d504e0ce1c4752808f7c3d87bf274806be29a5bc197c51356957"
    sha256 arm64_sonoma:  "5856906fcac8fd7b8e7cd5a518f9c335b6f57d9cecc78ba673989856fc2dd48c"
    sha256 sonoma:        "7e1bf988cd9f0bc1192e54baba27df76362ff086f2de0f8e18fa585a3cbeb343"
    sha256 arm64_linux:   "10c72e25679aac673d065bfb88954fdf92e00d488823602ce75636729e77ff50"
    sha256 x86_64_linux:  "090d4ab29d1cf54d0019fb0f60b19c81d0892d4d43e3512835d1fd11fab1d92d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qttools" => :build
  depends_on "qtbase"
  depends_on "qtdeclarative"

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
