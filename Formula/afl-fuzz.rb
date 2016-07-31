class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.22b.tgz"
  sha256 "9f5ef39927626fe107153ee0c886b0ac3cd16903d0261ca53f64e83e8404a18d"

  bottle do
    sha256 "d4d3b71d4254158694361419d91602b1f85b3d36dde092607b54cf203fb14bd1" => :el_capitan
    sha256 "8f12f72c2ce71f927302d16c591c4620c207c5987e600ff89ff83531a5d3f069" => :yosemite
    sha256 "532e797a074ad32e96080e3e0bfe14e45250e94106355abe47763963c69ee19a" => :mavericks
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
