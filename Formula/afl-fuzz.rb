class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.20b.tgz"
  sha256 "b7e2d422aa9bc104ddd2bf49f932d55c73627722cc38736124a8febdd64e9431"
  revision 1

  bottle do
    sha256 "45615dbfc6e941e169cf1a79c5b6f9e4a5cfa0d224c298671fff2bc35a5ec14d" => :el_capitan
    sha256 "e0358d1fad1b9b2b3cc469c76af74597f544c25b5f21786f9a9e3d5fd280b918" => :yosemite
    sha256 "c5a172abd3eafca72752850f8aa95deaa044fa42e2107bb08db86b94a59fdaa4" => :mavericks
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
