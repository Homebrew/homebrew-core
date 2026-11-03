class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "589a0de84e19584ea62da676466e339f71f553d5099bd9944770562a7188dd3d"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65dfedaa31eb96360878f1137acf23af0bef620b7629558fbc70068059855ac5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d5520584306023f16b046f2946b188631531a6c3f7f5b1ab5edcf86c793d0f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f5b8212340fd2e75703830ae4cad35e82538e9e6afdb56632cc41560710e1f37"
    sha256 cellar: :any,                 arm64_linux:       "a13a1d8d0f1afc2de84ecf65eeb64a73b38a44a6aec09116f525419d41e91c1a"
    sha256 cellar: :any,                 x86_64_linux:      "ede16f98efcfe6b2cd05644f067f06e59652d7be6296cea907f73c6ec5a07176"
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
