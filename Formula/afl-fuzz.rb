class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.15b.tgz"
  sha256 "427f4ed0393deea3b4520cfb0c8418acb21d6a048b24c30f50e65fc8a693c212"

  bottle do
    sha256 "8ef4b6a2d22a799a7246809a95a0d96d2e72ae351ec314ffe013e927f62baf54" => :el_capitan
    sha256 "fa384ad29a36b4ce2000b1f108664cd3d172129aceaa87cf0dc4776f52dfc5ba" => :yosemite
    sha256 "13dd38e0466c873cc74be36c8e47374169a0abf06e55346dbcf24ef4fe833e0e" => :mavericks
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
