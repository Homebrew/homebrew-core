class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.12b.tgz"
  sha256 "7fdc2d7f6ff7ff7ada27b84fec07f7e7910facb468c94db14861c295a9f830ba"

  bottle do
    revision 1
    sha256 "cac3bcc7e0955afa373a4b3f13b8dced52d463557feac53bf284b57f2bcaa16f" => :el_capitan
    sha256 "0e5c3298d296ab7ecb684a16ca6718c5d8de5b85cc17914f1db2bac62dff9677" => :yosemite
    sha256 "b326e3657a81b0d9bb120cf715fd5bd19f96b1ceb5c28b4bf2e18ff9aaf990e7" => :mavericks
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
