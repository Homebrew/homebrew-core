class CargoShowAsm < Formula
  desc "Show assembly, LLVM-IR, MIR, and WASM generated for Rust code"
  homepage "https://github.com/pacak/cargo-show-asm"
  url "https://github.com/pacak/cargo-show-asm/archive/refs/tags/0.2.65.tar.gz"
  sha256 "c6550e496cd0ae89f36d4be2741e832688a3c4e80b684f5506a622549cfeddb8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/pacak/cargo-show-asm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d2bce362fae80a9ba81095d9aa4e2a24fc9554c5840cd01a2a42135eea1a2726"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70774e5d99ae37b1415c53aecb36b1076b464de8da5a81c9e9c3a15c8b8364af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9648cea0036f4f7a71a05865078f058b6d3dfc625f5fc33b8083b84bce0d3fcd"
    sha256 cellar: :any,                 arm64_linux:       "996ca7ee5724d6c9ee709f3570f57b5fff3054796887f93234d67c0b84adf240"
    sha256 cellar: :any,                 x86_64_linux:      "36b01a1ebb84d26d64f8a3ee66d3611d85178d3f4ca5f6a526284363867ec47d"
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
