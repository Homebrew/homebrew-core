class Aflplusplus < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/vanhauser-thc/AFLplusplus"
  url "https://github.com/vanhauser-thc/AFLplusplus/archive/2.62c.tar.gz"
  sha256 "cde181ac733aa3a1212ffcb494bb9306a2086c7521fb006719b0e15cd8015c63"

  depends_on "automake"
  depends_on "wget"

  conflicts_with "afl-fuzz"

  def install
    system "make", "distrib", "PREFIX=#{prefix}"
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
