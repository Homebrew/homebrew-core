class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v5.03c.tar.gz"
  version "5.03c"
  sha256 "07f089e8591209862898c770a569d8e2b74b459fe967db323fc6a3924dcc82b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "34651d4371d17caa02a4ea5e3a0706c440b7cae51001c4d911ac1be1c9f128c7"
    sha256 arm64_tahoe:       "f33e4c13560716e131830031231cee4557d2412fdb42eb1d31e237d5bab245f2"
    sha256 arm64_sequoia:     "6f05cfb63fc14bfe6eca002a4f739412468393a274846f37851768ad63f8b862"
    sha256 arm64_sonoma:      "1457bb1c66fa4d79cbefa0e4e62ec8fbd5886ee708b50ffe0c656446ba155e8b"
    sha256 arm64_linux:       "0aa2f098482dbaf1632ce5c65287280c45d501c72e6aa23d348ceb4fe1d15b98"
    sha256 x86_64_linux:      "08a891c56269d274fd55b54c74a7587ff5540ed549032d4a9fb4724d4ba34fbf"
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
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin"

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
