class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.31c.tar.gz"
  version "4.31c"
  sha256 "8c6e9bef19b3d43020972701553734d1cb435c39a28b253f0dd6668e6ecb86bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "abee12c7b18bdf2ed365e8ee918359ea228856eb830ee1087509518e1bb5d900"
    sha256 arm64_sonoma:  "f251ee4eda369a02d500f3cf4e4ab04257da1bdaaecc441b98248f1ba997acc9"
    sha256 arm64_ventura: "d8ef6116499841451fdbdad67cdd92d8702900856e24dbcca89353d35b997728"
    sha256 sonoma:        "4be3e32c00bcd3d3b9e2c8caac281b4ee689388f9808c6a0c5e67c2209938b11"
    sha256 ventura:       "2c27f0cb1ace5806a81c09b387931218dc83e3305ec089b5f96e47a1ff36e383"
    sha256 arm64_linux:   "96a8fd8f8c94dcf4e4e3250d62aaa30c2620587247a328da51510855494cae09"
    sha256 x86_64_linux:  "2e7f44f003ef72667e05c9e5c078565d14e674ee04331782ee252e12efff5d93"
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
