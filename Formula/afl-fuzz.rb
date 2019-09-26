class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.56b.tar.gz"
  sha256 "1d4a372e49af02fbcef0dc3ac436d03adff577afc2b6245c783744609d9cdd22"

  bottle do
    sha256 "486079e79c19bff03bf1f9ff12aa85de32fe470669c16ff1fc13ad3303ec0da1" => :mojave
    sha256 "775cab0fd6828e3f239bc6663806fff049bef3bf38f698573d97f72b277f5b37" => :high_sierra
    sha256 "e562e6cb8546efed44bb47de67fe82ce9f4efa83802d6581e56f049c543211bc" => :sierra
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
