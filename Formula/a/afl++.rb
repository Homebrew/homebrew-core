class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.21c.tar.gz"
  sha256 "11f7c77d37cff6e7f65ac7cc55bab7901e0c6208e845a38764394d04ed567b30"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 arm64_sequoia: "250f5dba6ce572051f67ae75d75eabcd3613dde3f2927b45bb8cfe72e4e5dac4"
    sha256 arm64_sonoma:  "dc4b1f173c884c94f425778e0d165a4d1fdd59417eb271b70fa626af3174d2ec"
    sha256 arm64_ventura: "c99ff3ce07a26dd30716e22afe46b2872d645db463291cb2ef720edee6662bdb"
    sha256 sonoma:        "ac11de1cd176ad455ba1c4d325ecba42a1db02c431921a1094463cbcbf6bedf0"
    sha256 ventura:       "170d170077ea53a2a78f4c7926762f722ded361f8e7e08a3681f2fea55e64638"
    sha256 x86_64_linux:  "2f635704b9c3171d441c263f6d528caa79643e875e44ab96d605176ee2f46d03"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.13"

  # The Makefile will insist on compiling with LLVM clang even without this.
  fails_with :clang
  fails_with :gcc

  # Fix `-flat_namespace` flag usage.
  # https://github.com/AFLplusplus/AFLplusplus/pull/2217
  patch do
    url "https://github.com/AFLplusplus/AFLplusplus/commit/cb5a61d8a1caf235a4852559086895ce841ac292.patch?full_index=1"
    sha256 "f808b51a8ec184c58b53fe099f321b385b34c143c8c0abc5a427dfbfc09fe1fa"
  end

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
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
