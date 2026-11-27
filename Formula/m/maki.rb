class Maki < Formula
  desc "Efficient AI coding agent extendable by neovim-like Lua plugins"
  homepage "https://maki.sh"
  url "https://github.com/tontinton/maki/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "ef36113861acbf94e745caf5254d455f42047be9cc14d67ee2df32aa0929f77e"
  license "MIT"
  head "https://github.com/tontinton/maki.git", branch: "main"

  bottle do
    manifest_sha256 "5f9de68f9aa93016ebe30fd48f809b339ebe9ab50eadbb07396e22b32d31c791"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d68eb0b69b64fdba33975681a9e313c3733c1423f9a585f4416e98a9715cbc9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "499e717a85b0fed6172d9c0ae07242d20364f34a653bbd87edb0dcf739008993"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8f59ed2cf93830ff25300d3d401dd25aca8b590bf0cab2b8fce97871ae2cca5"
    sha256 cellar: :any,                 arm64_linux:       "41e357f23ca36501b1f0185c04a23ba9e090cfb1446cb89d7d63047ca7c5ebaa"
    sha256 cellar: :any,                 x86_64_linux:      "d68a782c83870b85504ad8585d609f0c7135f86993d9db5f12d12bf99c5fefc7"
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
