class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "f644dc4b7e20d214bfb1eea07adb48a1480aa8e5d3ce67be0e2135a1a615f10a"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23d31c1718886310c182881c77df1712324b4d5ce6874303e63d54c21c8c0352"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "279f43ce467a66e460b19365c1ae2c6ff858e090cd880d8c1e9b5578b9570455"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a8891536e7357fd864de6a01ee5b00eafc061025938104c988b21235f475104"
    sha256 cellar: :any,                 arm64_linux:       "3acf1cb6d0f29d1a3b0919538c4cd84e39a8b298822a3c6c91d065a65b4ce235"
    sha256 cellar: :any,                 x86_64_linux:      "2bb151964decac9e9fb25e2ab61e3c29a5f6fafe642f09578391f6a0aef51b72"
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
