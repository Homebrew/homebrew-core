class Never < Formula
  desc "Statically typed, embedded functional programming language"
  homepage "https://never-lang.readthedocs.io/"
  url "https://github.com/never-lang/never/archive/v2.0.3.tar.gz"
  sha256 "de4bf7f04c228f4f61e038f0c2befc41843f85c875f25922686c49c342b0f96d"
  license "MIT"
  head "https://github.com/never-lang/never.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27edab01757524441aafd95606dd1bea9d75e3e59e45b5ddbed4887eb15f0e60" => :catalina
    sha256 "5daef4a51095d73edd0e2a4b4fbf3b26abb3f038c0da41aa9cba4d77d7c1fd4b" => :mojave
    sha256 "a4aae9a3453fd5b3a0014e071c9ccb5be132a442d9d5ae54e810289a21b4215d" => :high_sierra
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
