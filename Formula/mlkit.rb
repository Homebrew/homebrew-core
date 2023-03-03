class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/v4.7.3.tar.gz"
  sha256 "903cbda07290297e87c62cbdc99b38c281311887858ef07f2f71f71de8c8839a"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 ventura:      "b1aa7324155eaa7933e816c9ea9118629016a049d4457fb417a7b1432997888f"
    sha256 monterey:     "61376968d1fd0f1f015b91c466e95083f490f388f5545110d552e5f167cd92f7"
    sha256 big_sur:      "22b875377b962b6825ea165799813cd663e16bcec6d32c0246fe318485a68093"
    sha256 catalina:     "27b35b7911c49dfa467a5da5a6770887ad704e3818a314e224d7a7bdae7aac8e"
    sha256 x86_64_linux: "ae7111a9fbb80886a67daef0e8a832eee38ad4fbc80a311eabcd877d1d0684d0"
  end

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on arch: :x86_64 # https://github.com/melsman/mlkit/issues/115
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
