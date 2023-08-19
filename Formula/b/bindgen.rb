class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.66.1.tar.gz"
  sha256 "adedec96f2a00ce835a7c31656e09d6aae6ef55df9ca3d8d65d995f8f2542388"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e314054f6b8dde2a61c23da989b1326be0837c0dfa5d9beb3cdfbb0f776fec62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57bbc2f94c859311e7cc50c39705c5c3742ae147fd5faa35bfdf33cbc5244f3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85624edeb85739ad89ee0491cdc3c1e682b097443dafffe28e9ff48969730d4a"
    sha256 cellar: :any_skip_relocation, ventura:        "b0e37f547dc0a121244eb71d200c0771551c09285f23174fe65c96306bd2869d"
    sha256 cellar: :any_skip_relocation, monterey:       "c224c1f9347367bfeeb7ff56d7b6e90238276cb8385c1c4922d5d0df055e91b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "476dc1854e0834c3d900a1932ad2d0c0d637220c5180aa065881a0a5bbc018f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a816fca8364e5092f0adea7dc6e3bdf041eff2099880267925a81f4d119739e4"
  end

  depends_on "rust" => :build

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
