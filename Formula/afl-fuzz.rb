class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.19b.tgz"
  sha256 "be12df9920c9cf68c412fb06ef5c7153f4b17e450b0195535a69663e749d8af2"

  bottle do
    sha256 "2fc711e05568970bca1d02966f497b2eeab44531957ed2b5276af67bec1ca06d" => :el_capitan
    sha256 "98b0fa1d7ad6ff5f98dbf4476e0e1bb27e241ce53e3bafc863d3ae476a0da353" => :yosemite
    sha256 "2a8c089ec92772c01156a6df8936119f842f50267728446a5bb2f694479cd314" => :mavericks
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
