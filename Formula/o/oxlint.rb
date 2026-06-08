class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.68.0.tar.gz"
  sha256 "379aaf70b70d96042849d558090323c8181a5c4208475f335ea76e7ee2b7f82a"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c98b1e14afb0a23229fc49a5084dbe7636ac788021eec3eef518d12346894169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acfc3bcd830497121dfe24790dee25f23c3721e915a33a862631e4c9cdf22f92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d2c75ec0669132090567ef28c5582c636dc017d107ceb2eeb3d6c9d390c5e61"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0281c5f3417b59dc9f62b36456680e6402d3fa80e2a41764d30e031b3e78c4"
    sha256 cellar: :any,                 arm64_linux:   "510528fffb16ce81fdf6b7ad250dcd69822f01d04fd9d4a4cc213638a6f24c65"
    sha256 cellar: :any,                 x86_64_linux:  "2ec7dbbf3b228942d7474d4eb29ff87117ebad50340f19eadbe07626a91a8de5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
