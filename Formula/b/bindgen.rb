class Bindgen < Formula
  desc "Automatically generates Rust FFI bindings to C (and some C++) libraries"
  homepage "https://rust-lang.github.io/rust-bindgen/"
  url "https://github.com/rust-lang/rust-bindgen/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "6a577026184a6f7a99b48f46f2074c83d272d3aadf91c7b94a4c6c34e6acd445"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc7bc08848387fb06e71502200feb95f6a3f4dd1847c45123eadf12b6f5a0c85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5996f7fb53fbde590c90d36026987f9504d875afb1d9363a980a68761abf5be2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45b8464a7e35f7924117201e091e0b684a388f54ea87db31fa0377da2f79a4f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6f6d163f499e8afc2ee1dd3aa0a675583dbfb9aba9e4475fc8bf18ca775f9e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "475a67777319788b70637d0fb73e93c002b8dc3d24ccecba68054b4801ea5081"
    sha256 cellar: :any_skip_relocation, ventura:        "6b5f70804e69b8132148caeae0c51ddf2810e2aee0c98e7015494c056308fd5c"
    sha256 cellar: :any_skip_relocation, monterey:       "7db30fe971452311f660f2daf029901416fb474b0ef68ff8deed59a3390d143b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e7db690c94974c33dd3fd1ccb5d9666789aa2c8fd9d669624c557d59915f1a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b77c4f67575fb6669885070548d7a703223d6022bc51a1698515186ef50bf3"
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
