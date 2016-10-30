class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.35b.tgz"
  sha256 "596167527ad7a69cf06dc8143a051eb8b2ee04f159447a3086f6e60ae460bcea"

  bottle do
    sha256 "de7f8ee88685eb4899824843cb8eacccac8459e749ef4b115c9a53489d701d1b" => :sierra
    sha256 "04baa7806593fe17b6c7eb2dd331a860b470cb36998bc8cf573938eea1249cac" => :el_capitan
    sha256 "cde9aacd6994924208d6f8b0918bf34f06ca7dbfd58847a80d0a5d10b45dcaa3" => :yosemite
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
