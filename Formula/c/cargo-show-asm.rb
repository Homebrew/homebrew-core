class CargoShowAsm < Formula
  desc "Show assembly, LLVM-IR, MIR, and WASM generated for Rust code"
  homepage "https://github.com/pacak/cargo-show-asm"
  url "https://github.com/pacak/cargo-show-asm/archive/refs/tags/0.2.65.tar.gz"
  sha256 "c6550e496cd0ae89f36d4be2741e832688a3c4e80b684f5506a622549cfeddb8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/pacak/cargo-show-asm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58595fc62e385a006f4a8f5fa715f210f61dcd46a546f2ab6ac776b3050f2eb3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "beac5c12d995e5f11378805d89fcb34abc0d4614f750418d52517103899ac962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ccdd36072c8a804b50bd3dbd928503bb2352b13a3bedbaea609bb4848d296074"
    sha256 cellar: :any,                 arm64_linux:       "b6776b801a58f65f011751daa2246ebb2970d7b3cab2bfa347dc3a879cdad6f6"
    sha256 cellar: :any,                 x86_64_linux:      "e2468a3bc9024bf5f179737bbc522d0eda5c0ca8a59623ecaa4ed1024b65ef46"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "cargo", "new", "test_asm", "--lib"
    cd "test_asm" do
      rm testpath/"test_asm/src/lib.rs"
      (testpath/"test_asm/src/lib.rs").write <<~RUST
        #[inline(never)]
        pub fn hello() -> &'static str {
            "Hello"
        }
      RUST
      output = shell_output("#{bin}/cargo-asm asm --lib hello 2>&1")
      assert_match "test_asm::hello", output
    end
  end
end
