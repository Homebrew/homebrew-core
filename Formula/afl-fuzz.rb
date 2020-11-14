class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.57b.tar.gz"
  version "2.57b"
  sha256 "6f05a6515c07abe49f6f292bd13c96004cc1e016bda0c3cc9c2769dd43f163ee"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+b?)$/i)
  end

  bottle do
    sha256 "958368e0937e051e3330ffa78f93481f8c729a104b87fd24c04ff067fb8780ec" => :catalina
    sha256 "82fb4d89ca48bc6a48c6d583497fcb48aa8e1fe7c00db57f0391881ab4a851c0" => :mojave
    sha256 "2fea83e82eca377b8adaf58a3b7f4577336db1a00f931170e0abc94a5c431529" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "AFL_NO_X86=1"
    system "make", "install", "PREFIX=#{prefix}", "AFL_NO_X86=1"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
