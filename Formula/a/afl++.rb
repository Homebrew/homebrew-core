class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v5.01c.tar.gz"
  version "5.01c"
  sha256 "5d33fb1eb59043a0c2b72e4ef38d235cd47bfdced503d4915f74002be6c75fb3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "54b9017df4bcc9086dda75eee50811b5f8e2f631079fa532d0d4023b54bca8f2"
    sha256 arm64_sequoia: "8d90e8eec72709c1005fe217907cc1637ecfb9b7bffea0753ce15834d1f582c0"
    sha256 arm64_sonoma:  "14941d0722efac1de4869d01ac6b9849f26826b92cb0d0be15fdfa5eb60b53c2"
    sha256 sonoma:        "3f4b2589a59b5cc996a5e76038e2c00280d51281412c0b2d840cd89adc273155"
    sha256 arm64_linux:   "e3c07c94a9e7b99114724611b984a513117bc05dea0f7355f3ebbe68d7509fb8"
    sha256 x86_64_linux:  "7d19b3d80760bd0129d14db1c39e1be620f018e160f2e415bfaca25faaa082af"
  end

  depends_on "coreutils" => :build
  depends_on "lld"
  depends_on "llvm"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # The Makefile will insist on compiling with LLVM clang even without this.
  fails_with :clang
  fails_with :gcc

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"

    if OS.mac?
      # Disable the in-build test runs as they require modifying system settings as root.
      inreplace ["GNUmakefile", "GNUmakefile.llvm"] do |f|
        f.gsub! "all_done: test_build", "all_done:"
        f.gsub! " test_build all_done", " all_done"
      end
    end

    llvm = Formula["llvm"]
    make_args = %W[
      PREFIX=#{prefix}
      CC=clang
      CXX=clang++
      LLVM_BINDIR=#{llvm.opt_bin}
      LLVM_LIBDIR=#{llvm.opt_lib}
    ]

    system "make", "source-only", *make_args
    system "make", "install", *make_args
    return unless llvm.keg_only?

    bin.env_script_all_files libexec, PATH: "#{llvm.opt_bin}:${PATH}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~CPP
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    CPP

    system bin/"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
