class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.33c.tar.gz"
  version "4.33c"
  sha256 "98903c8036282c8908b1d8cc0d60caf3ea259db4339503a76449b47acce58d1d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "4be2a31ddffeee2481371d88fd525f175393815b0322da250bffe14e75fd1a69"
    sha256 arm64_sonoma:  "fdcfde74d8ab2502051b1ccbe29c72d5518d87b57499d8629eff93f6b80ea026"
    sha256 arm64_ventura: "55bc5223b24b28b6fbcb40e1cb782a8990fa8c39bea155ea7bfbb6e203eb72e6"
    sha256 sonoma:        "d52df7a6744ce8dc02e52280ff1803330886e3f38e3a00a2990b67d4291fd38d"
    sha256 ventura:       "8ae4865731442dec5147643b4bc46d7604fd541d4fb8dbc02ae3cebec4e986f3"
    sha256 arm64_linux:   "96f8c0deab2753372a3df1434ad7b47e3878008d32473416d69a5b4ea05b2720"
    sha256 x86_64_linux:  "c7c70958537d3e76775e32c57c8d2d516b182886e988348f3e4dbf6f8d6710e0"
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
