class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.75.0.tar.gz"
  sha256 "31c650bd192cb9d4a2b7fac521a0817eb2bd04b04e2f12e763c036bdddd8b6ed"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6e2e0fc5a46a0c2f5e0cf94a068cb8debecf29cabd3778a1a47514977602f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95e7d91ce2811928ca60fa57e5b2609abcecf960909215f8e7bffe2986c50ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac61e735aea8deab7fae6c51ba6be43976b9588f3eac259e38be6cbaf3b12373"
    sha256 cellar: :any_skip_relocation, sonoma:        "c947f777c9930bbb969d0b1cd5c0d20d149cdfc5a2ff41e38ce3ec636c7e1c64"
    sha256 cellar: :any,                 arm64_linux:   "17087eafa3e716a67f38ba2d5a88d3e66657c0152d2010eceb5b61ba30fe74b9"
    sha256 cellar: :any,                 x86_64_linux:  "103c0b51b3d6361d10b993d6e03e0f71367a05a53469a2ab67124678a048c396"
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
