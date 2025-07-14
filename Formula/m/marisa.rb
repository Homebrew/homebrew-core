class Marisa < Formula
  desc "Matching Algorithm with Recursively Implemented StorAge"
  homepage "https://github.com/s-yata/marisa-trie"
  url "https://github.com/s-yata/marisa-trie/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "a3057d0c2da0a9a57f43eb8e07b73715bc5ff053467ee8349844d01da91b5efb"
  license any_of: ["BSD-2-Clause", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b617849fc8bb7a8c9ed63b5ee71fab11ba94ba0f00e8b63db1e2bc573ae4862"
    sha256 cellar: :any,                 arm64_sonoma:  "dc850a0aa5890573f4bb3805b44dd1595748ea7527aafc94d164f9a5a2ab8363"
    sha256 cellar: :any,                 arm64_ventura: "cbe7c42f5ed3dc9ac48d00460b63f21abc11e705a78271ab97a9ad33f8518719"
    sha256 cellar: :any,                 sonoma:        "d8cc02d1a54409724d92e360b3de75428f8e790121efcb06661f2451595f85f5"
    sha256 cellar: :any,                 ventura:       "e4a170f02d2eba533082e3f0f8c6197046963a35c3a4bf5c5e11d508d9b256c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673092e00b51563cfc9ecbceed7d8ade2636d31ea545e15d9404525f516e4f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c72c3f928765d60e2ecb504f95f3ed2b2e8e2ae2454b1e31d9b4b5ce6e4e3cf"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                     "-DBUILD_SHARED_LIBS=ON",
                     "-DCMAKE_INSTALL_RPATH=#{rpath}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <cstdlib>
      #include <cstring>
      #include <ctime>
      #include <string>
      #include <iostream>
      #include <vector>

      #include <marisa.h>

      int main(void)
      {
        int x = 100, y = 200;
        marisa::swap(x, y);
        std::cout << x << "," << y << std::endl;
      }
    CPP

    system ENV.cxx, "-std=c++17", "./test.cc", "-o", "test"
    assert_equal "200,100", shell_output("./test").strip
  end
end
