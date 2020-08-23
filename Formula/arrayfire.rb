class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.7.2/arrayfire-full-3.7.2.tar.bz2"
  sha256 "3f28c6c079fc0adffe2f7f62fb09f96a5e2143f6a73a3597c1b2022fbfdee30a"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "ee4a83613f9c2515a0b59a19bf83913c6f8f81646e5e0d024d2850508cc6925c" => :catalina
    sha256 "20ffb2185bdca09c2797186c17c7e89146b367c9c5c95f0602dfc02e4f14bb16" => :mojave
    sha256 "e0b0931974ffa870ec3e48f712aa0eaaaead6880214ba158f94215f70a2f2241" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "openblas"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DAF_BUILD_CUDA=OFF"
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
