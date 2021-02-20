class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://github.com/dpilger26/NumCpp/archive/Version_2.4.1.tar.gz"
  sha256 "e497f66bc3e827e34b9f5ba4ee90d1b4340d551f45af499d630cc3dd191c4894"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fac92d42c82fc628b8441e1ed25fc156e7f96cbc4b438b74ecd396b0a5e2cf06"
    sha256 cellar: :any_skip_relocation, big_sur:       "07e219c25f8ddd7b80e801b1f37cb1305af54fb907ab3f0c53bf66f4a8610c4c"
    sha256 cellar: :any_skip_relocation, catalina:      "ccbd4b3aa14f6a509aaf214162c3f1582acf374cafa9e2c8e9c4f1e3f0e11247"
    sha256 cellar: :any_skip_relocation, mojave:        "26c19afedc51463577541ce31f7641fa545bc73d61c7a563322281b0da7206e9"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <NumCpp.hpp>

      int main() {
          nc::NdArray<int> a = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
          a = nc::diagonal(a);
          for (int i = 0; i < nc::shape(a).cols; ++i)
              std::cout << a[i] << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "1\n5\n9\n", shell_output("./test")
  end
end
