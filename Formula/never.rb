class Never < Formula
  desc "Statically typed, embedded functional programming language"
  homepage "https://never-lang.readthedocs.io/"
  url "https://github.com/never-lang/never/archive/v2.0.3.tar.gz"
  sha256 "de4bf7f04c228f4f61e038f0c2befc41843f85c875f25922686c49c342b0f96d"
  license "MIT"
  head "https://github.com/never-lang/never.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f54d3641b651b918ece0a629b57f6ad111766b28ab9da6ce240dbaa4eafed776"
    sha256 cellar: :any_skip_relocation, big_sur:       "c861febee970af49c7a0f6003f8cabedda1b6f09d262c6f10c184103f68df306"
    sha256 cellar: :any_skip_relocation, catalina:      "27edab01757524441aafd95606dd1bea9d75e3e59e45b5ddbed4887eb15f0e60"
    sha256 cellar: :any_skip_relocation, mojave:        "5daef4a51095d73edd0e2a4b4fbf3b26abb3f038c0da41aa9cba4d77d7c1fd4b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a4aae9a3453fd5b3a0014e071c9ccb5be132a442d9d5ae54e810289a21b4215d"
  end

  depends_on "cmake" => :build

  uses_from_macos "bison" => :build
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
