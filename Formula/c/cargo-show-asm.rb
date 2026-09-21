class CargoShowAsm < Formula
  desc "Show assembly, LLVM-IR, MIR, and WASM generated for Rust code"
  homepage "https://github.com/pacak/cargo-show-asm"
  url "https://github.com/pacak/cargo-show-asm/archive/refs/tags/0.2.63.tar.gz"
  sha256 "d391fdea08cfd4e4638299ecfb86b56ef910b3f79f72462485b6e0713adefa29"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/pacak/cargo-show-asm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62d1339293830e40826742aa961f25da51316690f4f393b147c4dd0ebc01e289"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "876d25d0ee6e786ba1b34016d2c465a7ac2352cc15ff0e613199294280088429"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3bcfe7354fa1b4c6baef9970b3b9651940d6d8a33bb8994808d01275722910a8"
    sha256 cellar: :any,                 arm64_linux:       "c6efeee2dc0cb788f03d5cbc64cc5ada4d524d6416f34fff9a2fba0c687ec9e9"
    sha256 cellar: :any,                 x86_64_linux:      "30e2169a7e25ebc19cb128fb6bd074f2b8a739bf51f2ab19a6b227e3caf2ce91"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

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
