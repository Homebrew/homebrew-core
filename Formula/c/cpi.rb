class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "15a314e937dd05e62ca928a909305fa58052c764c7d313f79ae472eb0cc3c86c"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "92785cd813d9b3464394887b9c25f5e2920a4987ea11907dd2d14b013a57afd7"
    sha256 cellar: :any,                 arm64_ventura:  "a20eb54a55df6b579e43896bf79ce66429a0959c5d47d00b28b65676910455f7"
    sha256 cellar: :any,                 arm64_monterey: "9dd31910d940877880ba9c132eac936e99b351bf739744e038913e515b8ab022"
    sha256 cellar: :any,                 sonoma:         "4ea255114e1b6df199bcc2b0f77d2fb69318e554521b62827deadd752eaeea7a"
    sha256 cellar: :any,                 ventura:        "1bf20979f51c0b032ab17ed4283e2e1482c21d626f91674ed409e2641c7354e8"
    sha256 cellar: :any,                 monterey:       "4ee60a6c83ad0e9f9fe5ff9fb07e5d36c81289a48109d48c5c4c4f5f72451796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6f27a012f1278a8c4175c3fb623a9adea382cd94378d61bcc1098ab06df492"
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
