class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.30b.tgz"
  sha256 "5e0828ecd802916c01f5d167fccd6688fa78370754d3228bd836a77d2c518be5"

  bottle do
    sha256 "d7406ac351a5fb9d6219764d0e27480ae9cea8097320a7c98ba68c6a7c7c53e0" => :el_capitan
    sha256 "0bbc85dde543ef0f6b3183e8c84bc4ba358d001f908d1bc92201b7f6f076e0a2" => :yosemite
    sha256 "3b4ae16c807e65eda6f7aea8ceb9061ea0ef83aa5b9837ed5f3bdba3ef03feb0" => :mavericks
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
