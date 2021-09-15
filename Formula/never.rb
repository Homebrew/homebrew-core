class Never < Formula
  desc "Statically typed, embedded functional programming language"
  homepage "https://never-lang.readthedocs.io/"
  url "https://github.com/never-lang/never/archive/v2.1.8.tar.gz"
  sha256 "3c03f8632c27456cd6bbcd238525cdfdc41197a26e1a4ff6ac0ef2cf01f4159b"
  license "MIT"
  head "https://github.com/never-lang/never.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df34d4ced4bdcd4c56946166c0f4fafca87eafa475931644628ffb935236fec7"
    sha256 cellar: :any_skip_relocation, big_sur:       "6eba6d82763dd636acc89082030bf414648263e876741c3168c70676f6a8f397"
    sha256 cellar: :any_skip_relocation, catalina:      "8cd4e86723085d1957b1e86a4d62192ed66d3226e0c730c0cbe953d1e059a4c2"
    sha256 cellar: :any_skip_relocation, mojave:        "e22182439c9a1fbe0ce7f5535c809bfb387df8ca105aef5a14de1b735aad433b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7215993532fc94fb14b7c1782f868e94f6f8eef0585bed6d77dd876e1d548b09"
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
