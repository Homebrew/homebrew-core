class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.34.6/c-ares-1.34.6.tar.gz"
  sha256 "912dd7cc3b3e8a79c52fd7fb9c0f4ecf0aaa73e45efda880266a2d6e26b84ef5"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d161e49ada18225649329b60940692d87a4c9c34a3b4a32332457aaae8a176dc"
    sha256 cellar: :any,                 arm64_sequoia: "bb20019b663c40dc3662a036f7f951a8f5152b381473417fcc9a9810b5a97ddb"
    sha256 cellar: :any,                 arm64_sonoma:  "17f44048d8003b88231d69bac0408cf22be2f712ef8588d4933ff0811b92342c"
    sha256 cellar: :any,                 sonoma:        "841fe91739703803abef71c641ba40486291de060811779e6f6c6bbc79b0e83c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca10fb4f9f5160b28c1e2f8edce10eab5bda2ba18ba2ca083d915e65ad9c0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd24a61ed9ba623494903e02ebf144d4c87b05e7658013ba3590b8c1cbe234e"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
