class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "f56f3e529b6c3bb954a997a4c97f4b5d2d425e7a078428803624784eaed1b499"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a48e8aed8aa76f0efa7ed70fd9373f4a103d1a33eaa2ddcecc4bb24d42b9327"
    sha256 cellar: :any,                 arm64_sequoia: "d3bf08b3f16a80e47e60e5069a6f40fae0bc543a3aa95c18b90bbede7d0d4127"
    sha256 cellar: :any,                 arm64_sonoma:  "774fb1b2760baf8e39779faa61e4d75ed2041e62ed1e199e8f5c1407600d4516"
    sha256 cellar: :any,                 sonoma:        "c030076ba10edc7bd91d4fe57d386b2bcfea1c6c00311aac02c45251e73dfbd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe3211c60ad46f4753fdfb8d9e2c46757acfd684fba08db2d2d46f14c4bba14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f57105bbfacb083a3523871f80acb287f4dde789ceef34239f709ebb26d3bb6"
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
