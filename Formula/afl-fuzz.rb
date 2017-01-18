class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.36b.tgz"
  sha256 "d36e2643eaddbd6e79a0dd835fd6e23428198a7a7cd640e96ccbf21d5bd8bcc8"

  bottle do
    sha256 "cd205cd0f6246e86f0a154deffea52503e4229f4b2b52b4820d2732b310882a3" => :sierra
    sha256 "426ab3e3843666e30874587bfb87e5242c25f3dff933890d6e844b447661d970" => :el_capitan
    sha256 "83925bf57cc06e18f5c4e8530904afe8ca8640f6d792982de374b7aecdd7ff08" => :yosemite
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
