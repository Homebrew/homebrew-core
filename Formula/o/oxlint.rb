class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.59.0.tar.gz"
  sha256 "fd543182c2a8025a98530f666626f0890c2fcecfdb77dc6ee714fd24ace1b498"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdaa4a7aebdef6d14a7ab4c7cceccffce1fdf24517ea85fe55336f8e305b561f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e14febf9dfb9f5f5901f99ebf1a396eaa842860ff8341638586ef4f198cdb1b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cc0c19736252443cfb19cc95c1d2d0d664011400f7519452cde3c87dde87a5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1480e496e6c03dfe819bb101a4a95982247ce6717d2115c322b3c8edd6b1ec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a9ab283440fd85f87c8e653d253d5dbcf355775cbbf890e18951ccfd459afb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0a2a965b3d0ac1f029d5c43d5c3352323f2a5d6cf90534642e844e778d6497"
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
