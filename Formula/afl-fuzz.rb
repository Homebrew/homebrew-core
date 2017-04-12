class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.41b.tgz"
  sha256 "0670b13235264e688a7ccfbeeee257e9c57dcc86ead676247d92d199c194968f"

  bottle do
    sha256 "6ad0e561a360d9776feab1da1d89ddbabc7fd8dfd29db3014ce8df2bc7543450" => :sierra
    sha256 "dc6f3d74333d311663a112850fa663d7cff2d7a98831cb73af2de3028601beba" => :el_capitan
    sha256 "01bc90a7ed53e5f40dd791197db38cf3030dee7285815384b1fabd67e8c4b9bb" => :yosemite
  end

  def install
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
