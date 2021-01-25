class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.0/arrayfire-full-3.8.0.tar.bz2"
  sha256 "dfc1ba61c87258f9ac92a86784b3444445fc4ef6cd51484acc58181c6487ed9e"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "9869e0f31434835932fb93a6036b4d0bea62630b4392f076fafedda977ed5f8a" => :big_sur
    sha256 "509d9c63cc8f3300f4cd026bcc09645474d17d0bfe0bc9d9ca7241996f1a6e6d" => :catalina
    sha256 "da0132f5c4acb4d8e4b74a8f442175430ffc080a6a4ad8e0c3612a0bf92d1749" => :mojave
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
