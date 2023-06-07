class Globjects < Formula
  desc "C++ library strictly wrapping OpenGL objects"
  homepage "https://github.com/cginternals/globjects"
  url "https://github.com/cginternals/globjects/archive/v1.1.0.tar.gz"
  sha256 "68fa218c1478c09b555e44f2209a066b28be025312e0bab6e3a0b142a01ebbc6"
  license "MIT"
  head "https://github.com/cginternals/globjects.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f4e78cc1d1161dc273cd1a3bb0b920d11b1c249893bd39a69178d64704e2e0d"
    sha256 cellar: :any,                 arm64_monterey: "f268fe12c238a3714fd1bec33a818b7c372fb53e26f019596146538b2f2f7868"
    sha256 cellar: :any,                 arm64_big_sur:  "97b76d2b662c4f123604d312b442d2b59d606a3cc1e3e4f10cbe2dd3cc8b6f62"
    sha256 cellar: :any,                 ventura:        "c1531e62e47c2e3119d37d2647f3937f602387ca7c60bc41071177361dd23ab3"
    sha256 cellar: :any,                 monterey:       "4b2845c9354d14fd119544b28536d6fcfddd8f6c9d5eee2a5e01ff77c8b38f03"
    sha256 cellar: :any,                 big_sur:        "7a47a09787bf617fa6616f2cd88567b12b5d5c5d0a29225688908ed8c8b2c88d"
    sha256 cellar: :any,                 catalina:       "8093cb17f6c1ba5ce345d3a89f0a2330cbdbb88100ad241be0dd8611a6ad52d9"
    sha256 cellar: :any,                 mojave:         "9bbf36b86602a7b0c7bf66bb911e200e4f7b94f05c304afb261781edebf119ce"
    sha256 cellar: :any,                 high_sierra:    "baae740c033bc384454f81c0abba246f935765ec7decf408777d318d60cbe565"
    sha256 cellar: :any,                 sierra:         "dacabb07360fa768e54e9436f071a6ac2a56d0fc9da0d72b491fb8a645f48c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fe2640f8e2a366ca0d65e9afde39a1c60583af73fce21d22dadae53807c2b5a"
  end

  depends_on "cmake" => :build
  depends_on "glbinding"
  depends_on "glm"

  def install
    ENV.cxx11
    system "cmake", ".", "-Dglbinding_DIR=#{Formula["glbinding"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <globjects/globjects.h>
      int main(void)
      {
        globjects::init();
      }
    EOS
    flags = ["-std=c++11"]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cxx, "-o", "test", "test.cpp", *flags,
           "-I#{include}/globjects", "-I#{Formula["glm"].include}/glm", "-I#{lib}/globjects",
           "-L#{lib}", "-L#{Formula["glbinding"].opt_lib}",
           "-lglobjects", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
