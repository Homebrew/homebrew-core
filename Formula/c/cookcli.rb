class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "589a0de84e19584ea62da676466e339f71f553d5099bd9944770562a7188dd3d"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd0a621fe13f88c5cc52a2275c67314724b0507d7c1d3481acd9364d9acf8190"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2aded5e901f74430de7f0f92e42cf6574a7e22b4d68a31db2bbaa2ef029b385f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "208b1616e290bf9fc9af4c2fdbc6798ef8092652446fa132ecc00b79d732d562"
    sha256 cellar: :any,                 arm64_linux:       "06063250a78bb20f381bab09907fb4ca7c214600a0d2702152e46186b1c2a889"
    sha256 cellar: :any,                 x86_64_linux:      "71d25fa10add3a2fb90f8d673ba7049d15f308b63ca79bf27bab804ded0dcb4e"
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
