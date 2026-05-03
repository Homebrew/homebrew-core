class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.40c.tar.gz"
  version "4.40c"
  sha256 "3343796f0b69b0bec07e44033608280c360e0e90b4ddb6bdda263d598fc3e472"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c2df51739b4ef3e4bbf9ada1b5ab57c8fffc848fba7b98ff6fcdd511780b8bc2"
    sha256 arm64_sequoia: "f97a1c2a01bed341f7e6b69ff188b151e5dc834d1dd4f14aee67c53bf0b970c5"
    sha256 arm64_sonoma:  "9a12e059552523cd95101619d18cb4badcb30d4971234aad8ed7799044e5d63c"
    sha256 sonoma:        "297c153c14b348dd98806bd00f0307e6313f136201e5b3c82893c458143ab649"
    sha256 arm64_linux:   "fa49c337fd021355f5caf47f14b0b48267576edb017441b033fe7562c3717fec"
    sha256 x86_64_linux:  "59cc5f6537182866131bece8d8f9d79f7cab1f3b871fe0eaf5bfac7275b3c333"
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

  # Backport macOS weak ASan runtime linking fix.
  # https://github.com/AFLplusplus/AFLplusplus/commit/13b3c271a64a20718efb7900251c9669058a90ef
  patch do
    url "https://github.com/AFLplusplus/AFLplusplus/commit/13b3c271a64a20718efb7900251c9669058a90ef.patch?full_index=1"
    sha256 "6586d49352bdf137d6152c9b86207c8e3c31cf0d05386adf45f554fd68e7e89b"
  end

  # Backport macOS aflpp_driver ASan poisoning fix.
  # https://github.com/AFLplusplus/AFLplusplus/commit/f14ed081dd4eca99de1cecf74b45bbffc6dc4587
  patch do
    url "https://github.com/AFLplusplus/AFLplusplus/commit/f14ed081dd4eca99de1cecf74b45bbffc6dc4587.patch?full_index=1"
    sha256 "fccf1d1e58c081c801905a24de44804c6fed3376caa0806eced620ca2086dec7"
  end

  # Backport macOS syscall deprecation warning fix.
  # https://github.com/AFLplusplus/AFLplusplus/commit/1d5d7f0dd790e761dccd25efd8680b19ba2f3f7a
  patch do
    url "https://github.com/AFLplusplus/AFLplusplus/commit/1d5d7f0dd790e761dccd25efd8680b19ba2f3f7a.patch?full_index=1"
    sha256 "aa995d4989e7ae3e2892a51e2539f393a209d17ae2f32bb8b7fce37ddefb5b06"
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
