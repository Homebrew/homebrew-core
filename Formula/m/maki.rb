class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://github.com/tontinton/maki/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "5767b6a8db7e0603834ca673a5245a080e7081e42b5f94b238a647a580425a5f"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9aa5ca30d7546f4019f49c1658b1fc4dcb95aa5b098213c750990f0103e11df1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6bf4c1b58508c1b54785e00c51c95b0445cff394648a4bc021fae25b1f22530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a4909f74a3c2e377ba555436dbe5320f32b9274900240e85df12b81082044bd"
    sha256 cellar: :any,                 arm64_linux:       "c587a5f7eb198a19fdcc16ef23fea53f15e24f37638c3311d69e6a962a541d98"
    sha256 cellar: :any,                 x86_64_linux:      "18bc040e7343ba1256e9c3312edc7fd44b5e3d4cc2d4c4ff36a4877d49c0b042"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/maki --version")

    (testpath/"test.rs").write <<~RUST
      fn greet(name: &str) -> String {
          format!("hi {name}")
      }
    RUST
    assert_match "greet(name: &str) -> String [1-3]", shell_output("#{bin}/maki index test.rs")
  end
end
