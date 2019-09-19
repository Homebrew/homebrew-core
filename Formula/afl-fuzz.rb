class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.55b.tar.gz"
  sha256 "ca96fa6fac76f1ee104762cc9313be37a398f936f2b0e8a9f66e94244ae6babc"

  bottle do
    sha256 "080441df2377b8329b4f706b2e63279ec8735f908fe8db82dca30083c94f7007" => :mojave
    sha256 "71449bb1821214ea882cbe670cd54f66871736e50dbc1b2199e484cb92f9cd0b" => :high_sierra
    sha256 "01a55c1179d384dcd9a4f9c9d5e99963620fa50a5bdc12ab5136fd009f94802c" => :sierra
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
