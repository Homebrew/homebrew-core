class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/mlkit-4.3.9.tar.gz"
  sha256 "3c6adbeb9a85f7b3586d0961fd3b170ff31e09fa0ff12889b76b9ceb459059c4"
  head "https://github.com/melsman/mlkit.git"

  bottle do
    sha256 "a7573e0c4c56878666d398fc7cda30d7e443671be000213a9b3ebb4b8f741041" => :sierra
    sha256 "8f4c7800875845e48c5b180df646cd6edbc69962b255cf88cd0697b33038139a" => :el_capitan
    sha256 "34576a903b722dd652c3365bab693e922a5ff1c6496180739e7f69d9d65904e4" => :yosemite
    sha256 "d135d363084c710b4a417191c4c0bb785ddec43be117f1c382ea7a0eccdfb49a" => :mavericks
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
    (testpath/"test.sml").write <<-EOS.undent
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
