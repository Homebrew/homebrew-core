class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.9.5.tar.gz"
  sha256 "beb16142e08e5f68010c6e5014dea2276ea49b71a258439eff09c5ee3f781d88"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9e7224ee70fc1f78d5f1f031afe43b140badf13a4775ee36ba80f70710e6e79b"
    sha256 cellar: :any,                 arm64_sonoma:   "2f0eaa182942ffef4f0b3be1475fe866355bdf312925af2548a63ae31e79d65b"
    sha256 cellar: :any,                 arm64_ventura:  "00753cfc7f401ac5cdbc0b96f52455e446332cfa74e5d84a1d42331dec290a23"
    sha256 cellar: :any,                 arm64_monterey: "4a6a10dd45465631eec4bc7536df754279c7d3ce1328c5bc05bd9a09e675dce1"
    sha256 cellar: :any,                 sonoma:         "d911a4ef85de7d0ada39a6326a16c8bf7d4194edb35d2822701876cc6b364e73"
    sha256 cellar: :any,                 ventura:        "15e5d5a25bd144ab9e0a1f2081a5a1ffd916576c0618f0a71f414d84a780720b"
    sha256 cellar: :any,                 monterey:       "513efd0674e3ebc67f2ddd17f1911a3596fa2778948ad862cf71ef10da16545b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "71a81a0cac1d08293121e403655c424d7c72afb87cb40218bcef42f4bb631525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b623801ecd47f5dc48c230b15d7abc0fd05fc97404ad1ba1d8e3da9e536bb5aa"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/butterworth.cpp", "test/assert_print.h"
  end

  test do
    cp (pkgshare/"test").children, testpath
    system ENV.cxx, "-std=c++11", "butterworth.cpp", "-o", "test", "-L#{lib}", "-liir"
    system "./test"
  end
end
