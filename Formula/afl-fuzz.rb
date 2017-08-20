class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.50b.tgz"
  sha256 "0bdb0efd77b394b8b1a816e957a6dc27ffe01007d73c6247b9e424f0e36176c5"

  bottle do
    sha256 "b635f8b038bd859055a24b6213179566ced058bf60ea8964276ebf72ae8d5c54" => :sierra
    sha256 "d06047ac972f8e0e5e1a7f25a03e7ea7c43bcb4d86132bfe6f49139ae27138e4" => :el_capitan
    sha256 "7733783dd36acf0e3f004486a8c1e0432691bf529dacbf9245573895fcbbed01" => :yosemite
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
