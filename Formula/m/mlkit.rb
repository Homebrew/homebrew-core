class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/refs/tags/v4.7.9.tar.gz"
  sha256 "9886a7e18c474588a573e4786d0ed951bfd0c61d87690aee283c6bfcfac8db22"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 sonoma:       "cbd8ddc5ec83173bc5879743d3bbb46d9aecb5bac5caa986577d4edfaa359478"
    sha256 ventura:      "dcaf7ed6f4e314cd2c08dfaec5b2f7f58f1f8d3ba60962eb9bda1d0d69cf2fc8"
    sha256 monterey:     "81e7e4e1f7791517ecc9eeb235af5b175b2599a72a60b45152c7efffb5af788f"
    sha256 x86_64_linux: "ed32e3f95e9192c4495a325a840d4d33e3236dc031850be2a35892fef404352f"
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
