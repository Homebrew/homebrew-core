class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.43b.tgz"
  sha256 "9db797848efa9507e509379aeffdd89b3806a79a119dfa2c4477cc5156f262cb"

  bottle do
    sha256 "b429b6d439637fb304d7aebd43c00a76f80afd5ee3e096ae7f425f76b7bd4079" => :sierra
    sha256 "440d72bd576e1752d4aed8231c8565d7d028e86242668bfc2326954a1b0ff38d" => :el_capitan
    sha256 "7f48f8c2ec63bb342350246eb68d354ffeb45eb24b201d4c34862f828cb9872d" => :yosemite
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
