class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/refs/tags/v4.7.27.tar.gz"
  sha256 "c4e3aa2b1a1c9cd6f79d77110a9535b8c21478164967f77b737e38ce02dfd51c"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "e89f3c6ebd4a84752a9930b39eb312db0bcbfb72415c19ca915ac38e34e288ed"
    sha256 arm64_golden_gate: "f79f526d5ba87ba88f2e6cbdbf2bc385b58b0cfe546f04b873a33351d4aefab8"
    sha256 arm64_tahoe:       "9339a7e974818f982ee114a12ebcdee918c94342ba5007bd765a9027fb398f11"
    sha256 arm64_sequoia:     "dec13d45199ffa8bab62ee93c957eae61228aed979a39baf4f1f5c8dfa95605c"
    sha256 x86_64_linux:      "a78e23501f5b7798653b163540690077fcf1143f188a8ed8ea7da2120823d734"
  end

  depends_on "autoconf" => :build
  depends_on "gmp"

  on_linux do
    depends_on arch: :x86_64 # https://github.com/melsman/mlkit/tree/master#mlkit---native-backends
  end

  on_intel do
    depends_on "mlton" => :build
  end

  # Apple Silicon build requires building with mlkit not mlton.
  # Similar to other bootstraps, can keep on oldest compatible version.
  resource "bootstrap" do
    on_arm do
      url "https://github.com/melsman/mlkit/releases/download/v4.7.24/mlkit-bin-dist-darwin.tgz"
      sha256 "3d01153394d967b2fead9fa004332f087066fba3904677b15423ac06e592739b"
    end
  end

  deny_network_access!

  def install
    # https://github.com/melsman/mlkit/tree/master#native-arm64-on-macos
    if OS.mac? && Hardware::CPU.arm?
      resource("bootstrap").stage("bootstrap")
      ENV["SML_LIB"] = buildpath
      ENV["DARWIN_NATIVE"] = "1"
      args = [
        "--with-compiler=#{buildpath}/bootstrap/bin/mlkit",
        "--with-compiler-lib=#{buildpath}/bootstrap/lib/mlkit",
      ]
    end

    system "sh", "./autobuild"
    system "./configure", "--prefix=#{prefix}", *args

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
    (testpath/"test.sml").write <<~SML
      fun f(x) = x + 2
      val a = [1,2,3,10]
      val b = List.foldl (op +) 0 (List.map f a)
      val res = if b = 24 then "OK" else "ERR"
      val () = print ("Result: " ^ res ^ "\\n")
    SML
    system bin/"mlkit", "-o", "test", "test.sml"
    assert_equal "Result: OK\n", shell_output("./test")
  end
end
