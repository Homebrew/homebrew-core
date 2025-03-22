class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.31c.tar.gz"
  sha256 "8c6e9bef19b3d43020972701553734d1cb435c39a28b253f0dd6668e6ecb86bb"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)c$/i)
  end

  bottle do
    sha256 arm64_sequoia: "4094c5297ade783a623387c6b56b5a70daecb7d665c5190072430fd75b9bfefd"
    sha256 arm64_sonoma:  "543765f5f4f010a62d3e031754118f843f90fb5075abce697f943413f878978d"
    sha256 arm64_ventura: "5c1e2e059e2de3fdcf8385baa68397c8d0bda9e3b448d6a199b6625195361999"
    sha256 sonoma:        "57f97948c048d4bbe73bda674351a332fa1481213d01176dc6709a2cc8af1a60"
    sha256 ventura:       "937ee8b2f729f7009b412ea9e8feb26cf97728ab932d4c404bebb669dd0f72db"
    sha256 x86_64_linux:  "35ac3831a47d4e7dc815d91d888a3bad7f84291434dc3cdcc589712802edad73"
  end

  depends_on "coreutils" => :build
  depends_on "llvm@19"
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

    llvm = Formula["llvm@19"]
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
