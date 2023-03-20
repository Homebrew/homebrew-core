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
    sha256 ventura:      "a47a41ec1f94ff22c5cc6b9dee485f0f2ed6602d982e06468ed44610d7126671"
    sha256 monterey:     "bae121b30c127fac985501f34c6fd5eda0a419ae1c4f1e7f7a3f2a8e39e21c8c"
    sha256 big_sur:      "8755678ad2f8f363e8552d0acb42030e8b43bf10230a05c9f84607acb4c703fe"
    sha256 x86_64_linux: "ea0e8ce12fefec3a60774c400ce2de68f1be29ca0848e47332ada13be6dfc96f"
  end

  depends_on "autoconf" => :build
  depends_on "mlton" => :build
  depends_on arch: :x86_64
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
