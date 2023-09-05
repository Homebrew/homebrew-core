class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "55e98b851976d258c1211d3c04d99ce2ec104580cc78f5d30064accef6e3d952"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "0644ff18fbbbdcd97bc7ee35fb34cc72a0c127414915c214072a377031ceeed7"
    sha256 cellar: :any,                 arm64_monterey: "7976724f2069f2d9e22731c252016085021ca616755be85bec0e174092549854"
    sha256 cellar: :any,                 arm64_big_sur:  "c823b00a18be009c825f41c7da28e9bfbb545784b800ef95a64529164aff909c"
    sha256 cellar: :any,                 ventura:        "8d67f2ca90fbfa3d168571d137a7ab7deec1ee6a1f40cebb12d86adcc6d997e0"
    sha256 cellar: :any,                 monterey:       "6083cacfcaa25e3df4f5f124a4441818b6c9519ca5a5c7af34b8b2d12c4a1a8c"
    sha256 cellar: :any,                 big_sur:        "26b0d34177634a9682c2e5d5bca99ee4aa67198a60dd235369e2674e42cb17f6"
    sha256 cellar: :any,                 catalina:       "65f66e825d3c255cd2f888d34ce2552a7027a30655383c5a54b619bd610c84bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c06a6bc36bfdcfd3f3c2278d0ced9bcafc139681dafb0f322908eafcbe75da7"
  end

  depends_on "qt"

  uses_from_macos "llvm"

  fails_with gcc: "5"

  def install
    system "qmake", "CONFIG+=release", "target.path=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test1.cpp").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello world" << std::endl;
        return 0;
      }
    EOS

    assert_match "Hello world", shell_output("#{bin}/cpi #{testpath}/test1.cpp")

    (testpath/"test2.cpp").write <<~EOS
      #include <iostream>
      #include <cmath>
      #include <cstdlib>
      int main(int argc, char *argv[])
      {
          if (argc != 2) return 0;

          std::cout << sqrt(atoi(argv[1])) << std::endl;
          return 0;
      }
      // CompileOptions: -lm
    EOS

    assert_match "1.41421", shell_output("#{bin}/cpi #{testpath}/test2.cpp 2")
  end
end
