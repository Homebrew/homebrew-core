class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.30c.tar.gz"
  sha256 "7c08c81f59b6c1f0bc2428fdee9fb880520e72c50be0683072e66bcde662b480"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)c$/i)
  end

  bottle do
    sha256 arm64_sequoia: "46d322501d9639cf140773e8aa4c46b282689ca4879848fbd38acc4e28e6fde8"
    sha256 arm64_sonoma:  "400018c237b9178bc43689d1ab9b44e556b4951004d10ba10d988c1c7ab25075"
    sha256 arm64_ventura: "d6874424713e8fc3e4b22babb5670fba51b7a8934d9d9caf530c0731a9a013ff"
    sha256 sonoma:        "6de646f64ae790bdf5451fe00000fb935eb8e25f536b5c16d2f66ed8c5b402e7"
    sha256 ventura:       "8926bc6622d164d5a1c7541649aa244f5cf68bb08046a81253947c47c2efbb9d"
    sha256 x86_64_linux:  "f247017a775a382986974af0d87f75c95fc830bc9bcbdd08d30802a4b256d5a4"
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
