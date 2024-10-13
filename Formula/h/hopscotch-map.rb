class HopscotchMap < Formula
  desc "C++ implementation of a fast hash map and hash set using hopscotch hashing"
  homepage "https://github.com/Tessil/hopscotch-map"
  url "https://github.com/Tessil/hopscotch-map/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "53dab49005cd5dc859f2546d0d3eef058ec7fb3b74fc3b19f4965a9a151e9b20"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c7e9170bcfbca171cce4515cad7ff32963dfc5ae0f364a5e99ee20839c8682cb"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <tsl/hopscotch_set.h>
      #include <cassert>

      int main() {
        tsl::hopscotch_set<int> s;
        s.insert(3);
        assert(s.count(3) == 1);
        return(0);
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-o", "test"
    system "./test"
  end
end
