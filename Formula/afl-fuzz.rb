class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.39b.tgz"
  sha256 "968eceae4d013eee62bc8f2fdddbb7060b92e03a0175153b0285ec7f5c78f141"

  bottle do
    sha256 "fb5d5790f22074a91d8eb1da73a0752c4ee551fe043d9ce987d80fc993c7efd2" => :sierra
    sha256 "08ae52c1817603f0e61ccf1036fc09ecdcde1ab3ebec97b6b9578330971799e1" => :el_capitan
    sha256 "6acbad9ee52f58399e453d06cbfd6c2fe27ee7aa7741f9eeac041222e0fcaba1" => :yosemite
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
