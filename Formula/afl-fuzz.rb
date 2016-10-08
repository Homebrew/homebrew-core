class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.35b.tgz"
  sha256 "596167527ad7a69cf06dc8143a051eb8b2ee04f159447a3086f6e60ae460bcea"

  bottle do
    sha256 "0abf5e554ebcb0aa167bc504626321b95d69be3f31caeac0a6b49520aeec8910" => :sierra
    sha256 "c933afe09dca7f942c7344644521b6ef668d12d5217e4c8fd1956bfb31472c2a" => :el_capitan
    sha256 "56ae2635663584c0b6f96760ffcf0cae2d6bb917fbcf9f8acdec474f238a54ef" => :yosemite
    sha256 "b864829614923792369fe8bac742a2395353702d841aa55ec59c11fb43a51a37" => :mavericks
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
