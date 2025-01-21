class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "fb62a1e620850dcb69a1e65d0ff22c309c0469c876c718db017d0f92bcd114e5"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "83f1d3e84a6717be85bd5d5303ec9844674adb1815e8356f7689e9932916fb06"
    sha256 cellar: :any,                 arm64_ventura: "3e6533a18019a9eafc3a3217135c0205deb8fb63e05bd910698cf824e34d031d"
    sha256 cellar: :any,                 sonoma:        "c26b11acc67d50e9f14b8b510c899173bbb93dbb80aa49f5813e5548012fdbe0"
    sha256 cellar: :any,                 ventura:       "f991fc7314d3db3a6e74d13b3e120adfc6cd40311db2afa1586b013353c7522c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b330b5e227b479dea3cca97bc0a9e85d1e7b7450adf781236ffa96f1350e0e7"
  end

  depends_on "qt"

  uses_from_macos "llvm"

  def install
    system "qmake", "CONFIG+=release", "target.path=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test1.cpp").write <<~CPP
      #include <iostream>
      int main()
      {
        std::cout << "Hello world" << std::endl;
        return 0;
      }
    CPP

    assert_match "Hello world", shell_output("#{bin}/cpi #{testpath}/test1.cpp")

    (testpath/"test2.cpp").write <<~CPP
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
    CPP

    assert_match "1.41421", shell_output("#{bin}/cpi #{testpath}/test2.cpp 2")
  end
end
