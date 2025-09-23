class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "f1cf314377e3576b2fae021c82efc252f03cf17cd7b8186cc6937bb3b0ff71cb"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "6ea70f72f4c3ec5bde7ce53d9ebc8a79dd9135ec83f590b8668286648aa33e1e"
    sha256 cellar: :any,                 arm64_ventura: "950bd8ed8c9be7cf77e86e0b5bbd97f3128a943da8e9cd5e9918af4983345f01"
    sha256 cellar: :any,                 sonoma:        "b55eac0ab86ee9ec0eff6de91deeee2c3951e1a6a4732247524ef07a5aa5f4ed"
    sha256 cellar: :any,                 ventura:       "bfc54c256897170142b0fa6322c4ea5c6974eba9c2baf04235d8414717ba4873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffbaf9abd3b664c754c881208938414a5abde81082e703796fc3ef1318196af4"
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
