class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.93.0.tar.gz"
  sha256 "3de5a7bbadfe9b3c0aabb5b44eb9e319816d7eddfc0d7bd925aded5a6607836b"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66380deb82e9a87a7819eb5112c82a073bd23d28a4e11cd44762d71bf2851ce7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea0e4a211b353d1a1ff24ee3d5225261f9d6a02fc57e7417b3cc77d4f7a1f574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d4c026df76d59d51f224d6f10ce2d4a9fd96018c1b21ae837c9062c4cb19e0a"
    sha256 cellar: :any,                 arm64_linux:       "dd3b0c30cac431aa3c7a09b1d6bfc2808b572379c279168dd51ae9b0e9b0bfb0"
    sha256 cellar: :any,                 x86_64_linux:      "d411daadf6ceccc9bfc13621523b18d1e4c3be36875d7e1e131b30bce51b11de"
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
