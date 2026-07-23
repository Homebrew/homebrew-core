class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v5.02c.tar.gz"
  version "5.02c"
  sha256 "118415843e5d289d63bd6d8f2252c18212978f15ac9e86acbbc75766cd45acde"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a08c76e82f2deed0634e35b4447a5ea12b37814a236a2b0c0f92db36a0881932"
    sha256 arm64_sequoia: "93ea9be855ca2a1b3c0d191a3e6a21947dca7e0aa31340b2f9fe5cea0d1f542e"
    sha256 arm64_sonoma:  "0048a20058a4e870230b2dfebf27da2d072da464343b30b58ad4678f75cdd80a"
    sha256 sonoma:        "8856b27c4d4cf0aee89bc61d51164e3ecf062193f84184485800b2fd0c80cca1"
    sha256 arm64_linux:   "190a177af46d4dff6baf0564bca510e644095c461be2a0287adb45d1336542f0"
    sha256 x86_64_linux:  "fa3a4b32f0064229d5ac5adf7b744abf5032b6d3c3415a4305da648ee426729a"
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

  deny_network_access!

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
