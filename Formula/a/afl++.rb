class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.32c.tar.gz"
  version "4.32c"
  sha256 "dc7f59a11ce8cf67a3ed09a5ac78028c6f793b239b21fd83e5b2370cea166926"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d3981003e70e3748b65bfd413bd1034d6f95a4bc962128e7555bab38db762c1f"
    sha256 arm64_sonoma:  "ce9015f31f08176bca50eb207fa89ea7970df962a8afb887d5597c94c97bba60"
    sha256 arm64_ventura: "ef8a3dc7bba864eece4e9ee56f4c9f15cdbe03652ff2c830e0eaca58b6125629"
    sha256 sonoma:        "5afe8218e6fe35e02438154c46ce0dafbd97a04444e451b407974bd9da2db50c"
    sha256 ventura:       "ccf6081f157cac6dda19f4057bc6d061f8dea6faed0259ba4be279b1228fae94"
    sha256 arm64_linux:   "92d91deeb4540da360c8886d2b79014db02678586d50349fcfc16412d509eda7"
    sha256 x86_64_linux:  "048eb774523b3319f185d2f89d95ab831525d8d3cf3c0bf2c530d63a9597be39"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.13"

  uses_from_macos "zlib"

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
