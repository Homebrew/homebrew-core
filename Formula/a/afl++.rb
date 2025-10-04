class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.34c.tar.gz"
  version "4.34c"
  sha256 "b500b3d8012757ba6f3435814f7f36a474a1b722efce464216c87af0c515888c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "529b2888bcec3f03717df7fdacfc14ddab0e5dab07ad433d168129ca20451954"
    sha256 arm64_sequoia: "4dbd60b15c583bdfe56bf1bd3342aedebdbeb5b179138b34430503377d9842f5"
    sha256 arm64_sonoma:  "98335d68f9ee0b7eef244cdc226d547e2572ed4a37125895a86e2877358db902"
    sha256 sonoma:        "2173a3cd5e2a2754a09a1d52275a9d531aedbbc414eab8b446166254456e4f1e"
    sha256 arm64_linux:   "3e9187888bc3f7867e00cc6c4aa73c2cfbbf84bfcc1ae0f97118f61babc544f3"
    sha256 x86_64_linux:  "a284a3950157643798c9fd7241eb90a736ec8996d63cf528084642a59ef30cb3"
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
