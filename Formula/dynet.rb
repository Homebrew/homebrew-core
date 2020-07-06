class Dynet < Formula
  desc "Dynamic Neural Network Toolkit"
  homepage "https://github.com/clab/dynet"
  url "https://github.com/clab/dynet/archive/2.1.tar.gz"
  sha256 "72d5c2a0c7dece6b91426f02993f640297f6c5f7de1907d4eb587796e97022bc"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "2e0c6026d6a047f6c1885779da5e72f2503568b711fc1f7c0c00322814cb1213" => :catalina
    sha256 "06482cc7dee2e337482c31e935e9384cbec243a6c407e9e35aeb02f08361e450" => :mojave
    sha256 "f6603f28e5bf6209808e58ffbe27b7c8841a3bc00be1bc98d9aff6b4f8bf4f37" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
             "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3"
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/xor/train_xor.cc", testpath
    system ENV.cxx, "-std=c++11", "train_xor.cc", "-I#{include}",
                    "-L#{lib}", "-ldynet", "-o", "train_xor"
    assert_match "memory allocation done", shell_output("./train_xor 2>&1")
  end
end
