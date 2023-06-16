class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "d2c8e8c1c9fbabecaa1146a02cc3bbbf968931136e7dc94614af06880d291685"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a893676ea6095d756fdc3399c04fd07a18089fc221b776c6988ceb328791ec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "943f0413aca9c786a9614c278322569b5a7f859807d544073ac2b123a16b1daa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4d2411e1fbfaa06e29b9c361bc962955eecfcd7e3c7caa5e41008d4be8c3695"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad7b4df0ce012d907e0b9b5fe6aa4a00143b04d1c70e06ea987dcba43ce83fa"
    sha256 cellar: :any_skip_relocation, monterey:       "82e0434b354fcf4f7ca5051d1e1d007941b4e43ae06838701e402e000cf1ac9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "78bd8a155fd52350eec3618d98d8bc109233f497a00d11a57c454a38136bb1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f72976fc7f499ac823b452ad9def7367fcc1dc20ea17e133077cf17f35e3c2c"
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
