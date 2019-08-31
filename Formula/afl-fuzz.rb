class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.54b.tar.gz"
  sha256 "01933db5ed60bf0d62215a87d68bc42e9aa1ad7ca00db34d44d7a73eaeefa38d"

  bottle do
    sha256 "33a83a8fd62e5a4d4ae6fa098580b3f3926e6517debe77368e7c0290cf73f39f" => :mojave
    sha256 "4cd6b08ecfe35a62136b7a52222c59e055b80aef599404e29c7c9b8bf4f8fd50" => :high_sierra
    sha256 "b45ff3036dddc75cf64689b3f2660938834f393256315ed33ba72ed1924c695e" => :sierra
    sha256 "ef5e7c2e25020bf2d468c81ced4fdd9014dbdc0bb523f5acd8d91d8badc97d59" => :el_capitan
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
