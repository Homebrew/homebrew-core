class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://github.com/tontinton/maki/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "f2bde26015dccddd8c5a38424959248be16fd0a5ace0944724808f5df18fad6e"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7cfbd1a38e26228d7836da5d6a92ab33a5f706619857e1c9cfeb3a88a490a70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "337713abf61c3b85c10fccc3cebd39820ffec38bf693a61bb781c804f63a1a89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0582aabe94161055afbc552a14138436e38d09a845b7b7bdfc7cbbec4ebd3956"
    sha256 cellar: :any,                 arm64_linux:       "5c6578f1b448eff7d436261f34a47f0c4fe7996045f0fefaae7b68832364b103"
    sha256 cellar: :any,                 x86_64_linux:      "5cf4f08c0a145279f40568ee6894a3f2d0fb869fa6eb968d049810047e198b91"
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
