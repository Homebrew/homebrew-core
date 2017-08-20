class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.50b.tgz"
  sha256 "0bdb0efd77b394b8b1a816e957a6dc27ffe01007d73c6247b9e424f0e36176c5"

  bottle do
    sha256 "1bf1b8a6f6555ce5f631a2e0a88cc7c5955c61b6cf215c13a45942fbb4d950c5" => :sierra
    sha256 "5c58d38af10d8de25d06b223c838f962743a7d4598f61995055ee4fc7b9941dd" => :el_capitan
    sha256 "e7b405967b46dcacc56480cbd1f0ac2f20a027973271048ccec01b97ff68a44b" => :yosemite
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
