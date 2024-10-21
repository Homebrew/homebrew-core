class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.10.1.tar.gz"
  sha256 "8f12e2a2a3b515e234590f841268deb9cd69625ed2b70166d731660b590baccf"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b32566f5b63d81a06dcf43507b1fd0221d2d6275d7ab8979790e849d19cbbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f89be875fd92fc0d6caded52783f3e2f5ec1669afa788740e63a12c72da76bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f85563e00e7c0f9a7ce7da6d67d529d73d6f42b91dfaa34877a65846f8f0a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b8b2e82d148d61c9cd56da08a8d5f87402b3e741a282f303fa819b0ad745df4"
    sha256 cellar: :any_skip_relocation, ventura:       "6c6f6d87e4ec2c6619ff5c9524e91e2f095401b46a6d72cc4a45fb6ee498bec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce2b88d2b2bcd3b94d3257dcc603b52f261ee1138e789f7e3acfde9bc01ec98"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
