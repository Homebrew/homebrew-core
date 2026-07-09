class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "a8b86198eefcf262e8831e9691eb69d15b9b514aba282f28f471bb0fe7e54c36"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f771dd06a98c519e0a9576f6a679d0ab15e899014ac9e6bb5811110d527f6ead"
    sha256 cellar: :any, arm64_sequoia: "752ffd2ad9bbd2c801da3497fe20cfb2c30ea8d810935b1c595157109a82bc9e"
    sha256 cellar: :any, arm64_sonoma:  "4594edf513fd5cf6cbc37f1703139bd11c2a735b0537ddc44142a4882e3d8c25"
    sha256 cellar: :any, sonoma:        "898d699dd206f14039d10d0afa160209aa5b84c4f806f999280f32c321499403"
    sha256 cellar: :any, arm64_linux:   "b1a0fbdf6323461029f40fdf4df188f5214dd5d807728e6ab9b6be24994cbc1c"
    sha256 cellar: :any, x86_64_linux:  "ce98d2bd9a45d1e8d866097929051fed95f20cbb7a924a591bd1537fa936b522"
  end

  depends_on "qtbase"

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
