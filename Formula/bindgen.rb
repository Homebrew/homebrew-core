class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "9d987e7e2cefebed2c856ba36438e75af00aa08d4274fc15b8c20886065cb1f2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14d721bfd6ad85a861add404aa9b27245903e0b80902337c687271437f2552e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4c20b40beda1992176d32ad3a47d6ba563fa47533d9d81cdc66bed7ac9c71f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "253514b46fc4e5ee9b02be117e2eb445ec455dbb2c06ed1203a0139f9f764f27"
    sha256 cellar: :any_skip_relocation, ventura:        "f50d187bc0daf729a25b7ba91e67714ec568e20e250e4af60ca86370292f4182"
    sha256 cellar: :any_skip_relocation, monterey:       "cf9e35b68261da45fbb645ca1a8fe3a140d48ca7b060780ef1d89cc34245129f"
    sha256 cellar: :any_skip_relocation, big_sur:        "04f8c6213861437b779b0da1ef67aa31f477f3f3bb3240888645d52add544400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918d9eb3ec690bd000573d2c0843899626360b457712a52197d5829db977a392"
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
