class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.73.2.tar.gz"
  sha256 "5fc3277dd334e4bbbd7bdb8cad5d4fb87a667b2e95a2bae350a8d5424c280629"
  license "BSD-3-Clause"
  head "https://github.com/rust-lang/rust-bindgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77f8994564dd9ebc3824f0654a04a809923a36c15070e799dc879a435bea4248"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e1f6f5647fe9dadc55cc00f32464b20d8bd4548776160b9b28ca0b534d883b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d2850c8cade82b54cafa57c83c9d34b9b4cf3bfcdec39ede2e240a6ce5bc72d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7cbf162134163a763cd2c333edc33b17dc84f533c90e5e8ad26e4c826855afa6"
    sha256 cellar: :any,                 arm64_linux:       "ac6f5fd16ed6091a9f6dcd81997c707a02ce88b5b89e026ba39520647646e4b3"
    sha256 cellar: :any,                 x86_64_linux:      "5478da1b68e823bb3ec9993cda3771d30ab007cb89500bb55f95653074acb0d6"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")

    generate_completions_from_executable(bin/"bindgen", "--generate-shell-completions",
                                                        shells: [:bash, :zsh, :fish, :pwsh])
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
