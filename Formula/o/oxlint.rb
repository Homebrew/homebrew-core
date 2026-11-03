class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.91.0.tar.gz"
  sha256 "d3de075e077eeb7c025c80f7217a8a0644ba875a7ebd298f2fce1436c7470f6a"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6fa74d21a352eaf245a96ec011a912a9a5f0eb7b9aa7c1f07d577112538b7ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e93703ae5db4dff2f26434110fbbd1c06497a97cc56b0141c838a7dfadf84eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70eb09f843ca76b0a34c9c02a4b0aa3736eade0bfd980b8e127d9e8beff8c27a"
    sha256 cellar: :any,                 arm64_linux:       "01e557373efdbd5e6b694521b5ceeba50daabd35466cea2ff524d74e6afe821a"
    sha256 cellar: :any,                 x86_64_linux:      "d56974682e67528108793f9ef0b0f3a19f05f2186bb0a52cfbe173a24de49472"
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
