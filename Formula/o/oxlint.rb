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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7fd00c063a2335cbf6304daaec8ae1a001f3147a3d176cc9dc4f5ea11007caf3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "343b5bc49bdc0732901d31ebcb9cac703cb9fd82ec6780fc7174149bd0c12f6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f217cf6e8cf8dcd5e2551c2f5e6e05b85c4601e392f6d2726dd42ca4da7907e5"
    sha256 cellar: :any,                 arm64_linux:       "239385452fda65d63496ce33b1b419e7c85391570cf09703fc4851f81eb06636"
    sha256 cellar: :any,                 x86_64_linux:      "0d99b81f4becde6641b4bf3cb404d679707891e76a5a55ef75f2b65fd926fea4"
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
