class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/mlkit-4.3.15.tar.gz"
  sha256 "d047c7569318aef5160833aef434aee72c1aa5a7721e0db819fbeb9ad82bacb6"
  head "https://github.com/melsman/mlkit.git"

  bottle do
    sha256 "62c07bb142e52797537d38097653b3593954f5a2e3ea60c91eb0f377918962a9" => :high_sierra
    sha256 "3ef50b1e44b2c41bc888a830b69488ac927303cd45c79bf7c902cf3d4e9a0f87" => :sierra
    sha256 "6f88fc12dfebf563bd7ea7a96bf5a377c3e0fc0cfaed3c8205f9a75bcdec817e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on "gmp"

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
    system "#{bin}/mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output("./test")
  end
end
