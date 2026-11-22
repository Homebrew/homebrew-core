class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/IoLanguage/io/archive/refs/tags/2026.11.20.tar.gz"
  sha256 "62aa86656e65414ece414ef3a6ff5adbaf2bbe06e9847505d57628addc965e11"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "42fd43ea6740770f8c720663e0b55862d0d7ac0bca7c3b0e32e465f00963fd91"
    sha256 arm64_tahoe:       "f52b3f34e2163977455f08819a17df42ebec1148781c3df76411e3743e251d5c"
    sha256 arm64_sequoia:     "9cd4d01893fe007c243216871642b659664f5273c0bfa3e6ed52b253e2aa80e7"
    sha256 arm64_sonoma:      "ee036449cf0d3a7752967588f5acf9ad8057821346fa836f372b04a46a88f385"
    sha256 sonoma:            "9ceacf2ba834c91d5101adb7061bfd7c1ae702d9fbbbd9d8f78b5e82d049fd7e"
    sha256 ventura:           "914d9b485bd7ceaec9bc8e43c9ffff86560ced0074ea2ae73312c45fafc0e01e"
    sha256 monterey:          "2bbd166e8e51dd46f71818b6d2acad483af7cd19c2f8f114e5e713a64740d438"
    sha256 arm64_linux:       "7fb2cd769bab17e5a6e13563e09fb02bbd1da5e25d4fe541335b97f9f22fbc04"
    sha256 x86_64_linux:      "28f27659192940b8773ab23b0d237befa1ebb90ca6b771f82852422631f6549e"
  end

  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "wasi-libc" => :build
  depends_on "wasi-runtimes" => :build
  depends_on "wasmtime"

  resource "parson" do
    url "https://github.com/kgabis/parson/archive/ba29f4eda9ea7703a9f6a9cf2b0532a2605723c3.tar.gz"
    sha256 "d311cd3d051965485bff1c89a3980df7ad0ee3f9c0f33c18964d8c1cc32ef2cf"
  end

  deny_network_access!

  def install
    resource("parson").stage buildpath/"deps/parson"

    # IOASSERT returns an IoObject, not the UArray these two functions return.
    inreplace "libs/iovm/source/IoObject.c", "IOASSERT(ISSEQ(seq), CSTRING(slotName));", <<~C.chomp
      if (!ISSEQ(seq)) {
          IoState_error_(IOSTATE, m, "Io Assertion '%s'", CSTRING(slotName));
          return NULL;
      }
    C

    cc = %W[
      #{formula_opt_bin("llvm")}/clang
      --target=wasm32-wasip1
      -resource-dir=#{Formula["wasi-runtimes"].opt_pkgshare}
      -B#{formula_opt_bin("lld")}
    ].join(" ")
    system "make", "WASI_SDK=#{formula_opt_prefix("wasi-libc")}", "CC=#{cc}", "HOST_CC=#{ENV.cc}"

    libexec.install "build/bin/io_static" => "io.wasm"
    (bin/"io").write <<~SH
      #!/bin/sh
      exec "#{formula_opt_bin("wasmtime")}/wasmtime" run --dir=. "#{libexec}/io.wasm" "$@"
    SH
  end

  def caveats
    <<~EOS
      Io now runs under WASI, with filesystem access limited to the current
      directory. Native dynamic addons and Eerie are not supported.
    EOS
  end

  test do
    (testpath/"test.io").write <<~IO
      "it works!" println
    IO

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end
