class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "1e5c4160245d91f1667c5e55d0c6bbd977ac6b7565889bc01b38c462d7e2d95d"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fde96a3776323273d59b0353ebd3eb2282b4e472841dc69e4abd042d05af2a99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71188a033c9295c5e65f60ec149785b633d3780cd793e5dbb1a7b3971aa52eb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7db9bfe3eb7b6465ee0ac101c0aeccae98e65ba3b9a3ddee1a8bf4fa4d8c12e1"
    sha256 cellar: :any,                 arm64_linux:       "6a22f33b8a4d22ffda29483c29f4796419d474882d0723fdc0849464afe03b1e"
    sha256 cellar: :any,                 x86_64_linux:      "1ee02fee814745c24fecaa92cfe9bff253c2956ec3c130365070172675dc956d"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Build assets
    system "npm", "run", "build-css"
    system "npm", "run", "build-js"

    # Build and install the binary
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cook --version")

    (testpath/"pancakes.cook").write <<~COOK
      Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
      @milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
    COOK
    (testpath/"expected.md").write <<~MARKDOWN
      ## Ingredients

      - *3* eggs
      - *125 g* plain flour
      - *250 ml* milk
      - *1 pinch* sea salt

      ## Cookware

      - blender

      ## Steps

      1. Crack the eggs into a blender, then add the plain flour, milk and sea salt, and blitz until smooth.
    MARKDOWN
    assert_match (testpath/"expected.md").read,
      shell_output("#{bin}/cook recipe read --format markdown pancakes.cook")
  end
end
