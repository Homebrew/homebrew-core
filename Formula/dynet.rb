class Dynet < Formula
  desc "Dynamic Neural Network Toolkit"
  homepage "https://github.com/clab/dynet"
  url "https://github.com/clab/dynet/archive/2.1.2.tar.gz"
  sha256 "014505dc3da2001db54f4b8f3a7a6e7a1bb9f33a18b6081b2a4044e082dab9c8"
  license "Apache-2.0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "500a9235a348147fb8aa6b07f9618e9ae45d1a88c42504facc384f50cf0d1943" => :catalina
    sha256 "40496e31ece215e6f1faffc56eb8d674195f0f946cc100222d1d4a9762fd59c6" => :mojave
    sha256 "6d1bc8d99dfaff753f6bbea2d3da485de1c7494eec8b7eba85a9ea376eccfbcd" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  conflicts_with "freeling", because: "freeling ships its own copy of dynet"

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
