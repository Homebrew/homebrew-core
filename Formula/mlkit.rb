class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/mlkit-4.3.12.tar.gz"
  sha256 "d4221d049be8da23963cb45f88241d95e0ae7f98ddc40586ddce7380c5e0b3d6"
  head "https://github.com/melsman/mlkit.git"

  bottle do
    sha256 "f8f83c01a00ecc39102f0b4654bbd8c2c6ec7398a3677581a9b347ba3f26b118" => :high_sierra
    sha256 "a2fe3e019f1fb1931e264c051de8a41bbbe3fe1add5087126799a879c84598a9" => :sierra
    sha256 "d32bec8b0cc930dfd0341b88802a0222e7ccb111e8eefa43808033e1771ca37b" => :el_capitan
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

    ENV.permit_arch_flags if MacOS.prefer_64_bit?
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
