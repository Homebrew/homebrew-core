class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/v2.1.0.tar.gz"
  sha256 "ef73814657b073e1be86c8f7353718771bf4149b482b6cb54f99e79b23ff899d"
  head "https://github.com/Microsoft/GSL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba72f6e8b4795f9b785a45d76a411bd04f5c3020366cc366148e3cd06c0a8e7f" => :catalina
    sha256 "ba72f6e8b4795f9b785a45d76a411bd04f5c3020366cc366148e3cd06c0a8e7f" => :mojave
    sha256 "ba72f6e8b4795f9b785a45d76a411bd04f5c3020366cc366148e3cd06c0a8e7f" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DGSL_TEST=false", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
