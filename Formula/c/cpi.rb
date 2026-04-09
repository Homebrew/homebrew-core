class Cpi < Formula
  desc "Tiny c++ interpreter"
  homepage "https://treefrogframework.github.io/cpi/"
  url "https://github.com/treefrogframework/cpi/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "f1cf314377e3576b2fae021c82efc252f03cf17cd7b8186cc6937bb3b0ff71cb"
  license "MIT"
  head "https://github.com/treefrogframework/cpi.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ebc8bcf9165cc4f7d1fde637a79c4b871072c74b93358687311e97cd7e126cfd"
    sha256 cellar: :any,                 arm64_sequoia: "6bea475fa5b517cf42faebb459b104fc8d868dfe5e03cf097e37eb7fb0512a0d"
    sha256 cellar: :any,                 arm64_sonoma:  "391aa4186fc5c5c6f976bcf61bbd8ec7f311e352194b8595ad97da4db246a260"
    sha256 cellar: :any,                 sonoma:        "80aa4416afead86fe0621e8c53874dbfd951ff6fc40e8a7641c26cd1a382ab31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5748c1ce40a957f82c6e288901004c36c8b4aec5d8580828c561fd153e6388ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be937b51660f2d5f2664a132c73b928706be340356100c74b7ebb507c7ec436b"
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
