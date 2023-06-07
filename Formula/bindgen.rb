class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "e4f3491ad342a662fda838c34de03c47ef2fa3019952adbfb94fe4109c06ccf2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47c2779deacd1d7bcc17d1a7c89882bd4187f53d5b4a451143936e943fa9941c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12447e9dbe8e5b2bccfb5cdf8600596799849a70d3f5781651077a7df845363b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebc3193afa53274689a493435140fd1e3e1305339da335b6f393590febe9e658"
    sha256 cellar: :any_skip_relocation, ventura:        "eaa459279592fd2c135f8ad642c0cd08b00e36dcd59ec033d5db51a26eb41665"
    sha256 cellar: :any_skip_relocation, monterey:       "72cfffe3d5d3b98784b17d58a22e6d022a9c4e3835cd123e9d10f75c0d3cc999"
    sha256 cellar: :any_skip_relocation, big_sur:        "42d1b50d4413801d72048eb710bc70ee557e5abb2f508774d0c084965dce7e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b70141ecb5c5e299b740bdcb1bb23b164975899c87cca36091fe1d167ece996"
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
