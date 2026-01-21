class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.41.0.tar.gz"
  sha256 "a0e658476bb29f7f522af5255fa2704b1f2a37835a6803f73a092b5b8376e854"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4636ffec6c98d701b43ee8570cce5a80cea7e3889ce1756823d1773dd63fb50b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696d8d2a6a8058e7b63a8601a4646bf943a132f53854cf53a279724b804160dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c61c8f37995de38c85426b21596a00e7091b8d3241995d807a36b95add82ee24"
    sha256 cellar: :any_skip_relocation, sonoma:        "03fd50d7e08333c4408f003ef00a3d718dbcb6eba0ff35ccee7829921fe865ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e72623fded0f03b6933507e8303e4c348a0846877fb872454a88706e85e6482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c21c30856deb50953005a53269a8a7dff99a1f7623149349d8740923f5d5ad4e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
