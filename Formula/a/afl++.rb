class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.35c.tar.gz"
  version "4.35c"
  sha256 "b6e3d90ad65c7adb5681803126454f979e15b1e74323aecf2603cab490202249"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ea23bdd9186a4cfa39b5fbf8634d1e4d34dc1a2733417acb75a20fe1c5fbbb45"
    sha256 arm64_sequoia: "b1e041792c9906ce815d937f71e05b230940b39bc99928f94fef6dbb3e67a743"
    sha256 arm64_sonoma:  "3e346420077002bb673198f9ed7a07d7a96aea31c70bf614479ae0cf1a871851"
    sha256 sonoma:        "57372ca3578b746aaebe19cd603fabd5a0e06ac5679a70184a670ab067bb7e63"
    sha256 arm64_linux:   "950809662811e1b0b588c1946e6a2f4660ccb4b2b431f85af3dc74093a8b7174"
    sha256 x86_64_linux:  "bc4189526355cfffba4c168ee23cc9614ac58ff38e544cfa486c285129a34531"
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
