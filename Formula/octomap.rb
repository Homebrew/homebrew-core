class Octomap < Formula
  desc "Efficient probabilistic 3D mapping framework based on octrees"
  homepage "https://octomap.github.io/"
  url "https://github.com/OctoMap/octomap/archive/v1.9.8.tar.gz"
  sha256 "417af6da4e855e9a83b93458aa98b01a2c88f880088baad2b59d323ce162586e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "229cd1d731bb01140ce736fcfcf97e8c0f9e270233339e57c834b49a77b86331"
    sha256 cellar: :any,                 arm64_big_sur:  "4e1d89df8bbf973444851efd60273558eb8d3888c85d199f3350f0b4cb66e977"
    sha256 cellar: :any,                 monterey:       "b46273db2c913a4952be98b73811b6fc40683c37ccac8e2d4c8b3eb369886154"
    sha256 cellar: :any,                 big_sur:        "abf7287e17a8304b8429085bab4de3e99e484926db38148cbbc20d007bdb73a3"
    sha256 cellar: :any,                 catalina:       "280ae6e1d5528290fda17ad0522e1e7d15182ec9551ec4dec051ad8feddf232b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c17e275597d5b91081dc127ec9bf16d5baba52fddecf1b011523ed57a5d1cc8"
  end

  depends_on "cmake" => :build

  def install
    cd "octomap" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <octomap/octomap.h>
      int main() {
        octomap::OcTree tree(0.05);
        assert(tree.size() == 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}",
                    "-loctomath", "-loctomap", "-o", "test"
    system "./test"
  end
end
