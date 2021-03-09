class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/v4.5.7.tar.gz"
  sha256 "4e9f6cd23f7a32492249a9e6cd623ef03b103293e673c58f46ab5638473f4c58"
  license "GPL-2.0"
  head "https://github.com/melsman/mlkit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 big_sur:  "f92072962522f4fbcedb236507b180f80c56b3fcab6ae3aa59c2f1c15301b140"
    sha256 catalina: "53f00e638fc96f911c359a449d9e20f646e52b59c1d4f3a39812a29b6bff1cc4"
    sha256 mojave:   "ce5bb87a945b94e17a6e83e2e60a3be8dfcba7d2766ede87bab3afc2456c0e76"
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
