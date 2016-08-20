class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.32b.tgz"
  sha256 "3d08b79e28c2075aec20aa6e6240f9f6fb7af3d29200b498e908f8b3960a7b79"

  bottle do
    sha256 "86b74db2c626f2ac63671231059fdf048beba5399a0f958752387bf48cfe2225" => :el_capitan
    sha256 "27dc69c07ad9e98ce5ab5a597f8eae3541fc929f0a044304f14425953f60dcaf" => :yosemite
    sha256 "189f9ed5ad2524e0a8312b3ae3694873e843917c49ca29ce318ec7a0b8338b8c" => :mavericks
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<-EOS.undent
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
