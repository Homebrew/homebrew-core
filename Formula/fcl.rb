class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/0.7.0.tar.gz"
  sha256 "90409e940b24045987506a6b239424a4222e2daf648c86dd146cbcb692ebdcbc"
  license "BSD-3-Clause"
  head "https://github.com/flexible-collision-library/fcl.git"

  bottle do
    sha256                               arm64_big_sur: "8df5c85bcdd524bda6a6d9d90a862de8e517e79222371fad9593013d9abbdec2"
    sha256                               big_sur:       "64e20a01b7a05f081b6b01ebe88722a0afec56514940130c0720e2ee5e5325df"
    sha256                               catalina:      "05a5dfa094009376e5915ad14289490fa370462153102eb43e402d50663a23f4"
    sha256                               mojave:        "7fc28b6f1bd196e83873f61617e590af68ebf861cfc76af9d892c8ef40b25601"
    sha256                               high_sierra:   "625f6117a551777a1f12eba3253886a441a5a00e2759218b9566d40bb9f3ab2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c5eebffe537c48af33a456b80579565df2439c13ba11f7ed7d7a9875669117"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "libccd"
  depends_on "octomap"

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fcl/geometry/shape/box.h>
      #include <cassert>

      int main() {
        assert(fcl::Boxd(1, 1, 1).computeVolume() == 1);
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}",
                    "-I#{Formula["eigen"].include}/eigen3",
                    "-L#{lib}", "-lfcl", "-o", "test"
    system "./test"
  end
end
