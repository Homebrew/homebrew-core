class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "20e7b60eb5d0a98ba182d8fadc6e95d70d99c9935a391313e532fa5f6619bff8"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80718adc02a867a009b0fb55df93711cafbf01648ff7280bfac3db082d3f0018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e009c7f9a43fade1ce38db62673fb53e570a2135c25e9b24dda804bac3f4112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c936946d57ebe9af6734fe07735af1f2a215847cce1ea48db488a2ec08ee801"
    sha256 cellar: :any_skip_relocation, sonoma:        "af192a3b015c53f211777487a46b18d107a8c2dc197630a2395e7d78faf6d587"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca2fcf6efa96e16a8f43cb93d1db6a1572ea5a84d6e9171fd842a8acee45b925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "243e686d2be163a18ea2ab28eabad5b71ac1f76521f89cdd50b0ac2022019b2f"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    # Install npm dependencies and build assets
    system "npm", "install", *std_npm_args(prefix: false)
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

      1. Crack the eggs into a blender, then add the plain flour, milk and sea salt,
      and blitz until smooth.
    MARKDOWN
    assert_match (testpath/"expected.md").read,
      shell_output("#{bin}/cook recipe read --format markdown pancakes.cook")
  end
end
