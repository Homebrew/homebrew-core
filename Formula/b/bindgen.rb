class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "1da7050a17fdab0e20d5d8c20d48cddce2973e8b7cb0afc15185bfad22f8ce5b"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab793bcbe793c0693c14daff5b477d5397d7e069f3190189e83d9659c10f9bc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b11073237e5763df10aae7d7ce47533d170fb6155bcb5af6985fea0a6a131e2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d04ee15bd2faedceb86890fff428cae50dd287814d01dd45169e3dc83e1ea97"
    sha256 cellar: :any_skip_relocation, sonoma:        "a47ecb2e6c408618767f5705d70566fd137668b71141c7150e00a39be56c1dde"
    sha256 cellar: :any_skip_relocation, ventura:       "458de6ccbbc58a92745143b41dc87d5a91d6142e56c17a07b9e3ce8bba11b7fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02118889ab4a3a4e7b05450a38d9c7b363c2e2094d1e5333f88fba0324326438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd35d025d93161a3132f015b1f10a151c475dc6734bd80530b5f1d8105a53483"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin/"bindgen", "--generate-shell-completions")
  end

  test do
    (testpath/"cool.h").write <<~C
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    C

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output

    assert_match version.to_s, shell_output("#{bin}/bindgen --version")
  end
end
