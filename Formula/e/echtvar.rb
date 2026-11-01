class Echtvar < Formula
  desc "Rapid variant annotation and filtering"
  homepage "https://academic.oup.com/nar/advance-article/doi/10.1093/nar/gkac931/6775383"
  url "https://github.com/brentp/echtvar/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "e4d04d16d9c8e02aa9c216d7c7173e4d35ed3a9f848d05e5908d60e74b5c128b"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54fc2342877ecfd3d574aaa7b0cff67d24ded69196d3a1c848b6469e41e5c326"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3fe2aea1deeab2ceaa2fbcc917d73b5d655244193a96ccc4d1461ae884eb7c93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "498c3506736f3e62511db5b0bb5cc3c9122de0b93cb4327741bab82e2695e57a"
    sha256 cellar: :any,                 arm64_linux:       "826d7f12acf0cc484b033d88412e7264e8d888775496cb7abfd8bf1266ca5675"
    sha256 cellar: :any,                 x86_64_linux:      "470f5a5b37d81b6ce1bef2748d3fdb57eb63c65fcceca0f4ffcd55982232b478"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2" => :build
  uses_from_macos "llvm" => :build # for `libclang`, used by `hts-sys` bindgen
  uses_from_macos "xz" => :build
  uses_from_macos "python" => :test
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Resource to avoid building bundled curl, xz and zlib-ng
  # Issue ref: https://github.com/rust-bio/hts-sys/issues/23
  resource "hts-sys" do
    url "https://static.crates.io/crates/hts-sys/hts-sys-2.2.1.crate"
    sha256 "fc7e68eb880b02c80cfb41e8dc7904062a3ea7e27b7c4556e88d648dd2f038da"
  end

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

    # Use system curl and zlib instead of building bundled curl, OpenSSL, xz and zlib-ng
    resource("hts-sys").stage("hts-sys")
    inreplace "hts-sys/Cargo.toml" do |s|
      s.gsub!(/^features = \[\n\s*"static-curl",\n\s*"static-ssl",/, "features = [")
      s.gsub!(/^features = \["static"\]$/, "")
      s.gsub!(/^features = \[\n\s*"zlib-ng",\n\s*"static",\n\]$/, "")
    end

    system "cargo", "install", "--config", 'patch.crates-io.hts-sys.path="hts-sys"', *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp_r pkgshare/"tests/.", testpath
    python = OS.mac? ? "python3" : python3
    system python, "make-vcf.py", "2"
    system bin/"echtvar", "encode", "test.zip", "test0.hjson", "generated-subset0.vcf"
    assert_path_exists "test.zip"
  end
end
