class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/IoLanguage/io/archive/refs/tags/2026.11.20.tar.gz"
  sha256 "62aa86656e65414ece414ef3a6ff5adbaf2bbe06e9847505d57628addc965e11"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "e2adeb8a503d63e222798229921ba84b99569c6c7bd0b8cd4d9572af95cd84d1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1989a50d79580ba93dac2e907adf072a34540d82de032e3d04fca107b6c086d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1989a50d79580ba93dac2e907adf072a34540d82de032e3d04fca107b6c086d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1989a50d79580ba93dac2e907adf072a34540d82de032e3d04fca107b6c086d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a23c2bc844e818733def8868f7c89ecc4a471de6e77798d2723e157c3bf246cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a23c2bc844e818733def8868f7c89ecc4a471de6e77798d2723e157c3bf246cf"
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
