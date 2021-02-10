class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/v4.5.6.tar.gz"
  sha256 "11e8009fa58cb211c2c75f0acdac3039c17e8a8e9e5dadfbf49a62aa1487c5d3"
  license "GPL-2.0"
  head "https://github.com/melsman/mlkit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 big_sur:  "b70e43611b9fa05413c18b9856f132cc7fb679d6c0e82f3443a8e1bea8ba65ce"
    sha256 catalina: "60c0e8b1e5f24373a7215df2267b81f5b4e45764712cbf5e32feb5b2074227f9"
    sha256 mojave:   "2d29a94c7d467813252d23883ce92d73bcfae7b2cc788073442180f7a275e5ad"
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
