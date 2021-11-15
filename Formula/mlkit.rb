class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/v4.5.9.tar.gz"
  sha256 "ba664cc9a4a4d69a8cad75cfdb476b7ef8bc2379427ab573f07aa575a5f8200b"
  license "GPL-2.0"
  head "https://github.com/melsman/mlkit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 monterey: "07ce3a381a930aeb099d39bdc006d56d361e10b0163fd5f3283f916d0ed44a7b"
    sha256 big_sur:  "85404bdfce47bce19d60388027764be13704443d35d0a6a209f26c706bc998c0"
    sha256 catalina: "5fcc6bc3f5f766aae932ca05c2f58622e357b7b56e092b5e6f0336636306c477"
    sha256 mojave:   "3725fb0cd984d58e10520546ce2556a3bb5ba671adccf6f1e13eb8df7b5fbdc3"
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
