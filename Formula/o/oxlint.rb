class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v0.15.9.tar.gz"
  sha256 "29e9f047b434225044c5eb5bd5c02971a3e580b58559beb1fcfa455f7f1dfb33"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71b5a4186d5b7c628fe19bec9e31ada53ece5bee1198d335b15000d91968303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935dde5ae14a709e0995e5bcb798a22366ee78026cccdf2fc7ab5cf875cf293c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0a1c899405329a6b078ea7ba0200b3aae6853751e97001bef706c003a11dc73"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6d1b4097ba013d59fecdeaad8fecf6f90b21c724e3e937aee6a30fc5355ea25"
    sha256 cellar: :any_skip_relocation, ventura:       "6c60803b5dea4d7cdb6f69e627cdd5f89965063edba354af521227177cc3abc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d09d2e86dad969a14cfdb599b9d62a3e0728219dd48566ed837851f5cc2716e"
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
