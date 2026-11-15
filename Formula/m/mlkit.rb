class Mlkit < Formula
  desc "Compiler for the Standard ML programming language"
  homepage "https://melsman.github.io/mlkit"
  url "https://github.com/melsman/mlkit/archive/refs/tags/v4.7.26.tar.gz"
  sha256 "2847a8218c08aad2a47d2ad88a96775fc08be16e8c0ede325be2ded3947ddc97"
  license "GPL-2.0-or-later"
  head "https://github.com/melsman/mlkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "7f1ea92ced70ba0bb70db2e2607090b7c00b53069c7aca430ffb403af2b5b4fc"
    sha256 arm64_tahoe:       "11ce0e32d1125849e7f67400211f529dd3cb45e0ee6162fb76765ac4db494450"
    sha256 arm64_sequoia:     "6488cc157e360179fe024f12458503b018e5b993f9a5e74a2bec76bf3162a1b9"
    sha256 x86_64_linux:      "24b42e215e685e70836854f8e9b4a73a72ed3d0ff2fdac8782fd4f6b5977f867"
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
