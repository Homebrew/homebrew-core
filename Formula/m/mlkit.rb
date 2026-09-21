class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/refs/tags/v4.7.22.tar.gz"
  sha256 "b8dcf6047595da0bd1a5a18168d7f430eb74e9927c092d20bfeacecea9b8a397"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 sonoma:       "b541fe0ef24e6c2bd3099b2e12462de310d1358d6ed8c5ff817bea516bda408e"
    sha256 x86_64_linux: "1f19cf6f078616b113668e9b37766e0879746f64669c9634811b5ab320c6ca24"
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
    # AArch64 inline asm is gated on the compiler rather than the target arch, breaking x86_64 clang
    # https://github.com/melsman/mlkit/commit/f1811c7c8da109f4ef1a9d6314edb20f65d84cc6
    inreplace "src/Runtime/Region.c", "#ifdef __clang__", "#if defined(__aarch64__)"

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
    (testpath/"test.sml").write <<~SML
      fun f(x) = x + 2
      val a = [1,2,3,10]
      val b = List.foldl (op +) 0 (List.map f a)
      val res = if b = 24 then "OK" else "ERR"
      val () = print ("Result: " ^ res ^ "\\n")
    SML
    system bin/"mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output("./test")
  end
end
