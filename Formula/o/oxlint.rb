class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.92.0.tar.gz"
  sha256 "4a964cbbc0fd7a52a8cb9c2a4149ad74e3c82f57d4a02af25a639b238684200d"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64c62c6e1fcdd124d7bcc13f84df88942395a3ea01530f30ad8b6004ec962aa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cde306649217e592d56f46d1970c56c05ef67a2a249582e0b41f2afcad700118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64b3136e568ca9f8f588e21633358c6f225318d8eb1b790894c9480ce7f99a9a"
    sha256 cellar: :any,                 arm64_linux:       "142b6cb24b5dd0807037d93543377cc1ed8b22bf1559de8dc6c9134f1a00dafd"
    sha256 cellar: :any,                 x86_64_linux:      "dec22cb10949d52d1536fb7a5173d34c89739bb87cbd0738190fa59e4ccad76b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
