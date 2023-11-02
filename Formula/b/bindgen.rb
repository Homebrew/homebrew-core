class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "10790bb9863bff6a6f877b89d9d7cff7eac2ff0f45c1482f5edc9d9d0a82488d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89799f4d7b8d890abfd76547b0b0183dc7b88dd2eba8cbc49460dcb637d26581"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e2da70788d66ed5792b30c2d6bb34c11856c75fdfac2368f97b336c7940ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e226294bd01408918bdcfaebea0f3530bf892d73a57639b93cb4c224e366fa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c8871951aeb9aee0b9b9777f2aeb109065a62c1f53087e60c045d50428310b3"
    sha256 cellar: :any_skip_relocation, ventura:        "a62713c49444b3dbbc5c8138e8a7742d7c3fdce514711205a9d56870725ed706"
    sha256 cellar: :any_skip_relocation, monterey:       "9a09e5c3e46650e151b9c2b61faa920c4be5bb7ba0632d0e1bd8df7f7f60051b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ce62554f017d3b2ca4c8b682018d3bb1168a8cd5d01a89e8db1eebbbc43064"
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
