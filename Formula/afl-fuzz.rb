class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.12b.tgz"
  sha256 "7fdc2d7f6ff7ff7ada27b84fec07f7e7910facb468c94db14861c295a9f830ba"

  bottle do
    sha256 "fd14068c0b1a77e0942086ee8fe932cf3f4b8c610f48065e4829a21b0b4188b1" => :el_capitan
    sha256 "105ae5a97f7273fbab4df982892bde5af36202b0a119259610a5bac42fcf1b2f" => :yosemite
    sha256 "ab24747733b5fa8ea702855bafe36a51f4edcf0de1df5dc56cfad39f7ea00d4d" => :mavericks
  end

  def install
    # test_build dies with "Oops, the instrumentation does not seem to be
    # behaving correctly!" in a nested login shell.
    # Reported to lcamtuf@coredump.cx 6th Apr 2016.
    inreplace "Makefile" do |s|
      s.gsub! "all: test_x86 $(PROGS) afl-as test_build all_done", "all: test_x86 $(PROGS) afl-as all_done"
      s.gsub! "all_done: test_build", "all_done:"
    end
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    exe_file = testpath/"test"

    cpp_file.write <<-EOS.undent
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system "#{bin}/afl-clang++", "-g", cpp_file, "-o", exe_file
    output = `#{exe_file}`
    assert_equal 0, $?.exitstatus
    assert_equal output, "Hello, world!"
  end
end
