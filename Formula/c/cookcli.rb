class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "868ea0e05be14bce98e4cc89028e3a5d8a3fc6b2131b10376103db8a46b644c6"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a4a5120ce441297f2bf0dfd45553f43437b1130aded552d659a8890dfa7691e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "458efaaf7c89989189b3fe05ac2f9c73b045fd4dc4bb686050e680cc93f9041f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d9e31f0f7932b1455ec3f1cef8bbffc96ddb292aa87176d11b2958c5c34cc3c"
    sha256 cellar: :any,                 arm64_linux:       "5accf14a2848e5bee29c2d6925659f5646bbbd6122ab954e2afdf2f8f3cc9ff6"
    sha256 cellar: :any,                 x86_64_linux:      "d9dfdea5cb6ac996f27af217cd323621b4a827374d7601379d71f08b9347a279"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
