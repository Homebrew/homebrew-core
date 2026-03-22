class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/refs/tags/v4.7.14.tar.gz"
  sha256 "2fdffd543c9d8337e8a20d9270f5b1738873b78b631daa46735d5fd2a6b80ece"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 sonoma:       "d4811d05a7d8f1f90c4341f352abbbff6586f2887f4c646ea205487db66458ac"
    sha256 ventura:      "cf4286e1c5a3f318030c427fc17c4bebf559f39ea8a22ded62f6c85bfb0dd97e"
    sha256 x86_64_linux: "f27db5bb19c7b0adca6b68b048acf397bd816fae125ffd3fe311bc210cb0e18d"
  end

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on arch: :x86_64 # https://github.com/melsman/mlkit/issues/115
  depends_on "gmp"

  on_macos do
    # Can be undeprecated if upstream decides to support arm64 macOS
    deprecate! date: "2025-09-28", because: "is unsupported, https://docs.brew.sh/Support-Tiers#future-macos-support"
    disable! date: "2026-09-28", because: "is unsupported, https://docs.brew.sh/Support-Tiers#future-macos-support"
  end

  def install
    system "sh", "./autobuild"
    system "./configure", "--prefix=#{prefix}"

    # The ENV.permit_arch_flags specification is needed on 64-bit
    # machines because the mlkit compiler generates 32-bit machine
    # code whereas the mlton compiler generates 64-bit machine
    # code. Because of this difference, the ENV.m64 and ENV.m32 flags
    # are not sufficient for the formula as clang is used by both
    # tools in a single makefile target. For the mlton-compilation of
    # sml-code, no arch flags are used for the clang assembler
    # invocation. Thus, on a 32-bit machine, both the mlton-compiled
    # binary (the mlkit compiler) and the 32-bit native code generated
    # by the mlkit compiler will be running 32-bit code.
    ENV.permit_arch_flags
    system "make", "mlkit"
    system "make", "mlkit_libs"
    system "make", "install"
  end

  test do
    (testpath/"test.sml").write <<~EOS
      fun f(x) = x + 2
      val a = [1,2,3,10]
      val b = List.foldl (op +) 0 (List.map f a)
      val res = if b = 24 then "OK" else "ERR"
      val () = print ("Result: " ^ res ^ "\\n")
    EOS
    system bin/"mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output("./test")
  end
end
