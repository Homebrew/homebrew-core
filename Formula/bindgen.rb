class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "9fdfea04da35b9f602967426e4a5893e4efb453bceb0d7954efb1b3c88caaf33"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce19bba0f81971b5517afb0997acab5fefa180683786b528bce9160cbd77e327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a00661dfafacbf44742b2e4fe77f672c4a21ae0d5c3b4305da29a2300ff896a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b08bc403051311b3deef827f55dba52d36de4c94810571edca679599d7d75dab"
    sha256 cellar: :any_skip_relocation, monterey:       "48f5818462b55b67b17449a5daea309dcf4240bad0dcea85047f0b1383a89174"
    sha256 cellar: :any_skip_relocation, big_sur:        "512d25ddd8218657b139fa7860ab97c10c86b1e072cd49cbf67657c841e8e528"
    sha256 cellar: :any_skip_relocation, catalina:       "04078df6c17a3d866296698e2c6141fa0f8af7da1063ec92d7d2195b2c03547d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee1e2a9cdbe5a94e7b7848d97bcfac986b625cb8a4fece35ee227bb1c2af0ec"
  end

  depends_on "rust" => :build
  depends_on "rustfmt"

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args(path: "bindgen-cli")
  end

  test do
    (testpath/"cool.h").write <<~EOS
      typedef struct CoolStruct {
          int x;
          int y;
      } CoolStruct;

      void cool_function(int i, char c, CoolStruct* cs);
    EOS

    output = shell_output("#{bin}/bindgen cool.h")
    assert_match "pub struct CoolStruct", output
  end
end
