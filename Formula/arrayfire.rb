class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.7.3/arrayfire-full-3.7.3.tar.bz2"
  sha256 "523194f36ddba346d81c935b5f441f28af97e7454fd4196f3a6dfbf8d170e88b"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "8a95691693ed61d8ced4d856375205366d6ac3e86612638959e48e85d05eacda" => :big_sur
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
