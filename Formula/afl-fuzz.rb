class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.19b.tgz"
  sha256 "be12df9920c9cf68c412fb06ef5c7153f4b17e450b0195535a69663e749d8af2"

  bottle do
    sha256 "fcdc6cf59b19b7b90b81d78f0a9032cd4d2caad4e9e9045e5b66d8f17fc27284" => :el_capitan
    sha256 "f884a698413b111893375cd7ada63f27165edb99e2f7da2ec28265c4eb17319d" => :yosemite
    sha256 "96635d60db215892a1005eebeb48a3fa7c3aece9da7928898d4face24a220844" => :mavericks
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
