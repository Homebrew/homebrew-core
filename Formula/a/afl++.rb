class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.34c.tar.gz"
  version "4.34c"
  sha256 "b500b3d8012757ba6f3435814f7f36a474a1b722efce464216c87af0c515888c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "38501f46e62ba0ae835aedcc3964ebd52a2485dc360ce172919557a67c37a9e0"
    sha256 arm64_sequoia: "45bb110c26cbeffe6e43b3c544d133a10fbc58e5cd9efc966240368471e3266e"
    sha256 arm64_sonoma:  "8524f5f60c6b6c3a5d15c143ebf452518eccc779d435648f9564dba2dddcc676"
    sha256 sonoma:        "a0edabd4ae32fb7ee22d9efd61ce3b17419804e5cfb174b97d846a11795055e7"
    sha256 arm64_linux:   "edd24b5f5f8725c1152038783d1bb0d552fc5f5293cab154359e1d0f5ccdfe5e"
    sha256 x86_64_linux:  "95d898801603c750a683ba2b060ae108dc7abcd8bda78c59d03715f89c21018e"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.14"

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
