class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v5.00c.tar.gz"
  version "5.00c"
  sha256 "b0c005a1d28883ad1cad17ac01837d5c6b0cc7a72d19db700823e42ce3848534"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "627189c74dd069d1b9dbeef74e4e6126d1062569f7296ef6fa183f13902c4bcf"
    sha256 arm64_sequoia: "95abab94bbef303873968dfc735566442c0c19710c08b536d312ce63b4a3054f"
    sha256 arm64_sonoma:  "9311b83e1ff7c5ffd4d46beedec00136dff42c80d847a98896aab92452e7a84a"
    sha256 sonoma:        "a5c755e47d675d6c5fa1153428ece89daafcf0dd3af91c5684a0eff790533273"
    sha256 arm64_linux:   "6d429b266fb4012abaf1e9ec16050f7c484e472e2b403009ab1348df86226658"
    sha256 x86_64_linux:  "bb0d836771543fe44aa72cfacc2750d05f6d5f5145bbf947d9c346bb4d37534d"
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
