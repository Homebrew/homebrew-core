class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/IoLanguage/io/archive/refs/tags/2026.11.25.tar.gz"
  sha256 "a4e28b32e1fd9555eab1b1b082a500da11662a04404fcfef21f71536058167cc"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "328ee0be80bd91a839a883d99cb9707680cba18ab7d78b5af299ca90d633574d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd53319ad43fbcede559cfabb40d6dc86b53b7ab2ce68a15f1ace4ee40de8951"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd53319ad43fbcede559cfabb40d6dc86b53b7ab2ce68a15f1ace4ee40de8951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd53319ad43fbcede559cfabb40d6dc86b53b7ab2ce68a15f1ace4ee40de8951"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "463a088270d38b1281813571dc277704a37bb0c7126013770312623785061e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "463a088270d38b1281813571dc277704a37bb0c7126013770312623785061e65"
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
