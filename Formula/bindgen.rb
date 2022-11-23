class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "9fdfea04da35b9f602967426e4a5893e4efb453bceb0d7954efb1b3c88caaf33"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbe027671f716eebf26cfbe0ad2f8492290d7b0d7e41390934326055677ac845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2489628432e12b35a7b62c584c283639f0af4aaf207eb9a96953fd63825e93b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d9a74b9e5de386d249e64edd40fa05a5062fad7d5662d7cc7d192ab8fa8054"
    sha256 cellar: :any_skip_relocation, monterey:       "a1136ac2e299f7850812587021b52a15ffdb094c81899da4d72d7382d94d34d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d52be123da76cb2b8240885491216c2436831d9921f98ef3f3f5b54fb9cc2228"
    sha256 cellar: :any_skip_relocation, catalina:       "3720f2d2c4eedc2074a70713fa511a7080c0ad622c5806036b00407ba4be2544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c35644ffded1a001a480bea7b53ec066e4de82ef86e3e5c7455dc93d5c5952f"
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
