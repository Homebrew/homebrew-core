class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.43b.tgz"
  sha256 "9db797848efa9507e509379aeffdd89b3806a79a119dfa2c4477cc5156f262cb"

  bottle do
    sha256 "1a99cb8b0054b1c8fca257ef85b4f5629a009c7d4e81304b52cc70e59b5f57a2" => :sierra
    sha256 "983a57b6b32ae4d53be8f4944bf4b5bed2b0c98af04f5a831bbf88d047a32d32" => :el_capitan
    sha256 "53175ed5fc804c702985131e6458069dc3672c8d2a9b3e80be28694b304870f9" => :yosemite
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
