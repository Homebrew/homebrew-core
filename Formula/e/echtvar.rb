class Echtvar < Formula
  desc "Rapid variant annotation and filtering"
  homepage "https://academic.oup.com/nar/advance-article/doi/10.1093/nar/gkac931/6775383"
  url "https://github.com/brentp/echtvar/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e4d04d16d9c8e02aa9c216d7c7173e4d35ed3a9f848d05e5908d60e74b5c128b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b99733c8387d80230aa973fbc0db97f885d7a792aad7b6699855fdb94846effc"
    sha256 cellar: :any, arm64_tahoe:       "cccb0f49754be42e90f922933a99419073082567bf5526ebb80b131e3846a12f"
    sha256 cellar: :any, arm64_sequoia:     "38e002a6813dcdaf69846500bd6bfe924565d9ea8c96eb5c7a2d16453bcd4e29"
    sha256 cellar: :any, arm64_linux:       "bd21001a526b2ddded21f1e35baf7ad15f7df90a2f4898e314fd5f2a6883b0ed"
    sha256 cellar: :any, x86_64_linux:      "1c29e8ec6a808d0251e1318d1fbd3cb3f7ca23c59b1101faf7c0c7b8c3057ef0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "python@3.14" => :test
  depends_on "openssl@3"

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
    ENV["RUSTC_BOOTSTRAP"] = "1"
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
