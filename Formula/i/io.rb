class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/IoLanguage/io/archive/refs/tags/2026.11.23.tar.gz"
  sha256 "dd484ce9aa06014ed14b279fd4bd3116063cf8f2db91de92a892a3254e77cf6e"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "f511d41fbf396b5f9510aa9abe336c585d6b88fa1392300e550b7567a43ea285"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6a2188868a4c35901706ebad4dd1ece46392e1f12d1c77f374b6d480977c28d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6a2188868a4c35901706ebad4dd1ece46392e1f12d1c77f374b6d480977c28d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6a2188868a4c35901706ebad4dd1ece46392e1f12d1c77f374b6d480977c28d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1b4202ec4ca8ede4ab249b60e8d0b4634779913fac6b9dfefadd5ed4e86c26ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1b4202ec4ca8ede4ab249b60e8d0b4634779913fac6b9dfefadd5ed4e86c26ac"
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
