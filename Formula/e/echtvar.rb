class Echtvar < Formula
  desc "Rapid variant annotation and filtering"
  homepage "https://academic.oup.com/nar/advance-article/doi/10.1093/nar/gkac931/6775383"
  url "https://github.com/brentp/echtvar/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e4d04d16d9c8e02aa9c216d7c7173e4d35ed3a9f848d05e5908d60e74b5c128b"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "cb43da7beb5cec375582901a362420e496216c705bd5eaf79a2606cb9f302665"
    sha256 cellar: :any, arm64_tahoe:       "fcab74c9936cc1ab9df9caaf55de71874806f415acc052e33d9d74afaa3f0855"
    sha256 cellar: :any, arm64_sequoia:     "61155b5559826f1bae9d78090a0885528aafe6ce7c34307e9be3a6c77f533e7f"
    sha256 cellar: :any, arm64_linux:       "278794dce2a6315d3e2982e1424dfcf0a2a5968db8add141c38bb69dacb55670"
    sha256 cellar: :any, x86_64_linux:      "d3bcf5b3fc9a3e7f743673396ebbc6f349c762b1447a507198d87ebd1989c14a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "python@3.15" => :test
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for `libclang`, used by `hts-sys` bindgen
  uses_from_macos "bzip2"

  # Fix build with hts-sys 2.2.1 bindings (no lockfile upstream)
  patch do
    url "https://github.com/brentp/echtvar/commit/5d3b3600d0f3a9243b19ed5617076b46276c62fb.patch?full_index=1"
    sha256 "4ef184305ca098f3b8466b1c08e27354c346aa01653312af99cff657a7c2459b"
    type :unofficial
    resolves "https://github.com/brentp/echtvar/pull/59"
  end

  def install
    # portable_simd feature requires nightly.
    # Use a stable-Rust stub to keep the CLI buildable without nightly.
    ENV["RUSTC_BOOTSTRAP"] = "1" if Hardware::CPU.intel?
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp_r pkgshare/"tests/.", testpath
    system python3, "make-vcf.py", "2"
    system bin/"echtvar", "encode", "test.zip", "test0.hjson", "generated-subset0.vcf"
    assert_path_exists "test.zip"
  end
end
