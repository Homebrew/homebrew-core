class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.26b.tgz"
  sha256 "504140f4f234ba12413ec446f31d2204228efa1b8b755b44e31283293489eff9"

  bottle do
    sha256 "96b43d8f4361fcf21a79ca7d76ca22271ded74741a99eb7055a61a2ca4673400" => :el_capitan
    sha256 "bc8120ce6d14fb0ad5fbdc20690c3adb530034e174798a235b4a69d599ca9770" => :yosemite
    sha256 "6e4ccb5bbedb664b767abaa4158b1791f9f4792785c766f5f7beb01e4024b80b" => :mavericks
  end

  def install
    # test_build dies with "Oops, the instrumentation does not seem to be
    # behaving correctly!" in a nested login shell.
    # Reported to lcamtuf@coredump.cx 6th Apr 2016.
    inreplace "Makefile" do |s|
      s.gsub! "all: test_x86 $(PROGS) afl-as libdislocator.so test_build all_done", "all: test_x86 $(PROGS) afl-as libdislocator.so all_done"
      s.gsub! "all_done: test_build", "all_done:"
    end
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
