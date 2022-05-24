class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "55e98b851976d258c1211d3c04d99ce2ec104580cc78f5d30064accef6e3d952"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "18715516745f887dcb1d69011aa8fb5f17b93fcde903d64dd26eeb668517904a"
    sha256 cellar: :any,                 arm64_big_sur:  "7fe73ba73e1c1218519a80cf06734e6952e499f62dba585ae99926934ada40b1"
    sha256 cellar: :any,                 monterey:       "e5dcb9488c5a2f0c44481d6841cad4915b7fc111e7541f34cdaac34784a0506f"
    sha256 cellar: :any,                 big_sur:        "ced5a9ce120b015e98bb2f7d8926b60614ffec9aa658dc3d2523cdd6cda2c98f"
    sha256 cellar: :any,                 catalina:       "15bd4967f912b104af24e246ede702a49245e85baefff0e8ba404fc67a22f5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4711e3edfd0c9c249453df3f12ceb9c239524a1f2edfc478f15a900f7127c1ab"
  end

  depends_on "qt"

  uses_from_macos "llvm"

  on_linux do
    depends_on "gcc"
  end

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
