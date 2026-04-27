class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.62.0.tar.gz"
  sha256 "3f1f60cc6a8732f3a95d540620f79e46f58f425c6fdf18370cd02a1ec1f7e24a"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34adaf08e745ca945b3cbc0e077b8c53cb0ec08593c5e3e3f6b1105057416fa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b7e24e5931017eb4c3ab914fb93dad30543dd294bd5d721eb855491964e6626"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc123da4fd48ecff4325a3319829d3c1cc3e82ccf4151eb4ba6d3cb76a0d1d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "14eed31337202dbe370236c493b2316c2ca2811b5f5236e2cf434612e7c6f95e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd98d1366e1249581b6e2e46f0cd2d1c6174e59ae542e2a823f19edeae9fdb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a1a7846654ef80be6d37a451fe6cdd34519b26d0c5b6fc9432c0ae8819d3d6"
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
