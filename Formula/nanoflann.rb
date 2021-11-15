class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search wih KD-trees"
  homepage "https://github.com/jlblancoc/nanoflann"
  url "https://github.com/jlblancoc/nanoflann/archive/v1.3.2.tar.gz"
  sha256 "e100b5fc8d72e9426a80312d852a62c05ddefd23f17cbb22ccd8b458b11d0bea"
  license "BSD-3-Clause"
  head "https://github.com/jlblancoc/nanoflann.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b1659e04d7ed33328e8b3bd5c8d59118c4bb659312b0e5fd950a8e95c66371e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd4506127f2bd65002f11b2deb0b2f6b636fd864bee4a4294fd6123b9c94b6b6"
    sha256 cellar: :any_skip_relocation, monterey:       "6c1a86e9f04c5d93398998affec01ed2b49aafbfdb48d1e291070762ffddfa3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ce420030884830f6b94c1fa7304d647ad4ceb44622a56781e94d2c3e8c5ca6c"
    sha256 cellar: :any_skip_relocation, catalina:       "a0cba3b9ca8e124b841a62554ebbf71234253b6706e779c0e928a3a012bc2598"
    sha256 cellar: :any_skip_relocation, mojave:         "0df3f7eb8bbea15676f63d57c96ac6ad7ebd74996a496ee94adff7845799a651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a70a8dace8f5f823b993f32246c12b5cff47c551fe8326c4338871bfb2b874f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
