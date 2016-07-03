class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.18b.tgz"
  sha256 "cffcdcd9f02f81634b82c2b34a174c1c2552fbc9be92245d8fb87c78b37d06a4"

  bottle do
    sha256 "184b3f7000cc856b475138d2cd80277abb5c70e82cb08fbdfa9012b765061b8a" => :el_capitan
    sha256 "ce12d0d8fb882b8a6ced1632ebcda56df7e42a0d2fabb4c6302dee9aa35760fd" => :yosemite
    sha256 "a1128965560c9c58ab2ecc426c5f9abd7447bff4f879302d145b12c01d30a3eb" => :mavericks
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
