class CargoShowAsm < Formula
  desc "Show assembly, LLVM-IR, MIR, and WASM generated for Rust code"
  homepage "https://github.com/pacak/cargo-show-asm"
  url "https://github.com/pacak/cargo-show-asm/archive/refs/tags/0.2.62.tar.gz"
  sha256 "fa49db55969fd1d627daf88214995f5907c9a9f076baa6dbbca56f1afbf73b03"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/pacak/cargo-show-asm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4d9be4aadb7d4d767cc20f97a4029490842b86a5f16f83aa2b0cf807ac72140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb97375bd038261fd0f99772627925a325b979c861d985d91a86ae97a051c5c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba4fd404ba4a5ec376614e3273fe3cb5c2ae75ddd8b1e9d4c23d73a4d2d96114"
    sha256 cellar: :any_skip_relocation, sonoma:        "0af8329cf99d77c21e719aa61a8505452a40150a9a29963c36bf7e9121a58558"
    sha256 cellar: :any,                 arm64_linux:   "f9b415ed141300e7f4e5111892ef5234b17488157224cff4de870745774ba6ea"
    sha256 cellar: :any,                 x86_64_linux:  "a73752bb7daa48ec4d826e3c263c5f2385241900f5a071885890679274dde8a0"
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
