class Never < Formula
  desc "Statically typed, embedded functional programming language"
  homepage "https://never-lang.readthedocs.io/"
  url "https://github.com/never-lang/never/archive/v2.1.8.tar.gz"
  sha256 "3c03f8632c27456cd6bbcd238525cdfdc41197a26e1a4ff6ac0ef2cf01f4159b"
  license "MIT"
  revision 1
  head "https://github.com/never-lang/never.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e65bdb33bc931bd228cf68d7af2f69da95f06b5d8c72a5f8acdeeedd7f57a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b905f6979c6ec036a74152d97e91f781f172605191ba4d44bd6dfc15ec541850"
    sha256 cellar: :any_skip_relocation, monterey:       "14ea02dd081e33a0b890e056e233678f5df727f8c27c04bb09a71690bc12f395"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbf2f7aa7d819529ef54afd73a0e06b3f4fd828444d11d0a966450b12cdc0c34"
    sha256 cellar: :any_skip_relocation, catalina:       "1ee5c77bd6eda59076c0c33e38b3b0ef75b27350b0a4f2947923b9a0a177022e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d23bf87c23cbaa07bf607416d7d6da8d2a217046ab6858e4108cbdb9f1baff"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"

  def install
    ENV.append_to_cflags "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "never"
      lib.install "libnev.a"
    end
    prefix.install "include"
  end

  test do
    (testpath/"hello.nev").write <<~EOS
      func main() -> int
      {
        prints("Hello World!\\n");
        0
      }
    EOS
    assert_match "Hello World!", shell_output("#{bin}/never -f hello.nev")

    (testpath/"test.c").write <<~EOS
      #include "object.h"
      void test_one()
      {
        object * obj1 = object_new_float(100.0);
        object_delete(obj1);
      }
      int main(int argc, char * argv[])
      {
        test_one();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnev", "-o", "test"
    system "./test"
  end
end
