class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.10.0.tar.gz"
  sha256 "13b53f14d276adf6cafd3564fcda1d4b3e72342108d1c40ec4b4f0c7fc3ac95a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "317685b9afecb323ab66baf7ddd1fc71fe1bf38ecafc1c619b9eed54323686f9"
    sha256 cellar: :any,                 arm64_sequoia: "d4d36001c5a821f3d7aae49213dfdf489b65f099f79e6c8d71e92b6a5fa02da4"
    sha256 cellar: :any,                 arm64_sonoma:  "b08b3915658ff5cfbf1c5286e2ec5a64a7f6bd2a83c8d479805536767ec21d9a"
    sha256 cellar: :any,                 arm64_ventura: "fce931c03ab9577bd8a564c7b70cbdad3b5ff08fc9e0f46b7ac637a16b93de2e"
    sha256 cellar: :any,                 sonoma:        "1dfbb17db4c2289d4c96225fcde00438cb116fdeb78e94c09e772fd1d8493320"
    sha256 cellar: :any,                 ventura:       "5ed6de11a8deb8e386f76ba3cfdd070fae5065519962b12b0bdcfc8086b62141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2099517c738a6e833f534ae384cc77adee1a399f84b043c718dad87d84d83e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70477ac82f71d9275b48ec51ab83ebbc57292d072f0f511ae9e237e924950076"
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
