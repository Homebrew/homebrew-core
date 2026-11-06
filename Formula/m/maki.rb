class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://github.com/tontinton/maki/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "f2bde26015dccddd8c5a38424959248be16fd0a5ace0944724808f5df18fad6e"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bef9293130bd1a676a9c0228c86db3505632ecdcfdc9efcb54b1294f306e9e38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1435c465d4e2aca4aa51ccfb0dd77d6c402e8fa4c58dc263d200e843e2bcc01c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e0d2678cf123124dcb4dd5070a1e56277aac19368632b8b84ab9ecef7a64f36"
    sha256 cellar: :any,                 arm64_linux:       "b02c0ba767c3e7e59b7a9b40ac9ce218bc2942d1e9938c518018f92264d172cc"
    sha256 cellar: :any,                 x86_64_linux:      "6c83176edf56bf7e6202d8753255faa70415c4012045f824b827290cf8d50f9c"
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
