class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/mlkit-4.3.9.tar.gz"
  sha256 "3c6adbeb9a85f7b3586d0961fd3b170ff31e09fa0ff12889b76b9ceb459059c4"
  head "https://github.com/melsman/mlkit.git"

  bottle do
    rebuild 1
    sha256 "506bb73d7421593ea3bd76f8958ce61d161c9a7e724c525b1b32bedae61fa8dd" => :high_sierra
    sha256 "2f6e573272e385556c38437c83017ce3ffb9279b091bdd3f6d815d6ef401940b" => :sierra
    sha256 "3b1eeb563a56a67b8335bcfe94359482b068d12b9a34b033158ee642a2536056" => :el_capitan
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
