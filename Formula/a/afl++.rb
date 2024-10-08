class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.21c.tar.gz"
  sha256 "11f7c77d37cff6e7f65ac7cc55bab7901e0c6208e845a38764394d04ed567b30"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "bc36a276193f8bc347b58ede62c96289e5f4760c49df5b34880af7e1b096adef"
    sha256 arm64_sonoma:  "007e43ccfcd0ababf4201c61ca8bd5af261aa2d8ccd92554dbe07f90466adf08"
    sha256 arm64_ventura: "19152794969e4f6a35db1cfce3bba890a624ce00d60f0eb562fa9ded84026af7"
    sha256 sonoma:        "0c1fb8e9a68cb26013482eb476e1b137193aba3c4b99e45ea53d16adc602a2a3"
    sha256 ventura:       "e1339535ffd0683a2f9159054ed40d603a2071398a90acc0b76c470810a2e0b5"
    sha256 x86_64_linux:  "e303493ba40b6ba430be07a4eaabe3ed65c86308dbdff712be5c16a527f808bf"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.12"

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
