class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.6.0.tar.gz"
  sha256 "1012d2b31a9dd6f962dc5e1ebf6a65058d2b0dd1cf497e5c404589adf822e38a"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63875c59db982fd814cf8928a91704a4bd894437a277fe34e5b5abc28547ddf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c12cf25e3c05e6a7db03c8cdaa3e080ae3dd98fc176fc1ba419611014dff2afc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc516f75a6888f6b047c7c6bef14f8f4e9c038371d5876c4d379063a5855506b"
    sha256 cellar: :any_skip_relocation, sonoma:        "32a320b6b637b0b5136d458ee2bdb2882ea8d619f235b1d6a89f3efba63825b7"
    sha256 cellar: :any_skip_relocation, ventura:       "fba9e71c4044e1df22d9c8575e38ea4fa5eb9f6db62d50a7a468f548d25a9aca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef4969bddde86f3754bb70610faae50cb3afacfcdf8ac81ddb1c05e5d9d0189b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d05d090b67456bdbeaafb09e4aa8e3974c9455e3fa4b8f3c4ef7875bca2da7"
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
