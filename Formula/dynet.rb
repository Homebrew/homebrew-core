class Dynet < Formula
  desc "Dynamic Neural Network Toolkit"
  homepage "https://github.com/clab/dynet"
  url "https://github.com/clab/dynet/archive/2.1.tar.gz"
  sha256 "72d5c2a0c7dece6b91426f02993f640297f6c5f7de1907d4eb587796e97022bc"

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
    system "./train_xor"
  end
end
