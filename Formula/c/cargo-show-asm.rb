class CargoShowAsm < Formula
  desc "Show assembly, LLVM-IR, MIR, and WASM generated for Rust code"
  homepage "https://github.com/pacak/cargo-show-asm"
  url "https://github.com/pacak/cargo-show-asm/archive/refs/tags/0.2.60.tar.gz"
  sha256 "7758624e0364d34f86827a8fd076f370f0dd0611d8762c88701ec396c69fd840"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/pacak/cargo-show-asm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8346ccb211a892203d90f7f85ba14cf4549317eb835cf11a9ebe8f357fcbabf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84da33e8d3040b7f1da5442417a45b0cae7e17e1ec1426c10f38f9b77597e507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b8b0cbc4a0b2da37876db2c41c9a2b359ed904779ce941498359c61a76c897"
    sha256 cellar: :any_skip_relocation, sonoma:        "70703bb23fa63f7279addba525fc60cbbd53a108eab2162f55ce35a7322b9b27"
    sha256 cellar: :any,                 arm64_linux:   "8800b19e0f65afdca42eae292da994af41a0e04f70fc66ef77daedf4eb075a66"
    sha256 cellar: :any,                 x86_64_linux:  "2c243ad3966af44ae7826709cb01bf1cf2e48bff23712ffe1e2130e236fe1daf"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
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
