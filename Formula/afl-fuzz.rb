class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.14b.tgz"
  sha256 "623c01059c3615c4e9ee17893dcedc75d87b74e64232b969f44f9d90d3f0b229"

  bottle do
    sha256 "c04574a43387ac041857df6897fe932c0cc06f215607d6160e88fbf7ba41f345" => :el_capitan
    sha256 "e706ab7838ee7d2e2ca4151974c96b2f4ec288fabd1e8f42eb02f09f2f70f2fd" => :yosemite
    sha256 "37e97d40e2523754a19e599dae4cf723ac4dddffcda7de492447f3f2619b93a5" => :mavericks
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
