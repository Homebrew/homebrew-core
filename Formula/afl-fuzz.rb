class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.41b.tgz"
  sha256 "0670b13235264e688a7ccfbeeee257e9c57dcc86ead676247d92d199c194968f"

  bottle do
    sha256 "27b5caba2f6900fa2e4c34e2044d871da014e6885244efb1558a90ff7916432b" => :sierra
    sha256 "b12ec142936b9471b3727a6b149681b918dba0b4d1f8c74e39a2e9b3e4d73f47" => :el_capitan
    sha256 "c74d3911ee38596f0dce92f09359a497457aec038933dfaf677c87262e427e84" => :yosemite
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
