class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.33c.tar.gz"
  version "4.33c"
  sha256 "98903c8036282c8908b1d8cc0d60caf3ea259db4339503a76449b47acce58d1d"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "29ce287e229663622362168cc454a4ace7c3aca064ca7812126dcf4e92ea00e8"
    sha256 arm64_sequoia: "f2d8c72f3f2caf2583dc9398eff3755e83366104d33af4a8dccb32024269217e"
    sha256 arm64_sonoma:  "13fd0d4d75c16d02683d30ccf26feedd10334b019b735e290edb50724d3f2dbb"
    sha256 arm64_ventura: "626c4a4502254103442ca657df6f41ea3f14693d054ea5466eea875c9f7e8375"
    sha256 sonoma:        "ef2048668b8da39f52a10a78482e76f3b354adc2a04bd5035fb4a73a6b44e215"
    sha256 ventura:       "39da01c00e47af500cfa1fb500faaf4c2d703b5bc4110b32638c874d5e2f979a"
    sha256 arm64_linux:   "288b6addabcc7371e593364d06d6cc124409fef97dcaca5458dd48541f49d1c9"
    sha256 x86_64_linux:  "21c0e7d582386c4451833e3fa518643b8d24dc8526a229e459f4ab5d6d2fde92"
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
