class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "300a38aff510178dfd057d134735bc80fd4acbbc28ad5f8f5ca18a9235249fd5"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4f3558a78572d45b72c59eaba5a766f9cfde6400b68c0e0c78e3674da20d0e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fec907fe1536c0312a78c9f519f1cb3febb7872f2bab67716a0d5a0a46aaee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "810156b8d205e5eafdf41990ac9f734cfa3b0190cd319a352533b676039612fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "62dd16e575acfacc03042361933925249a4cf06d439ea445a419cf7d43c13a59"
    sha256 cellar: :any,                 arm64_linux:   "d097fd36cd6bb7b53908e014645dd6b6385366521059dfcca3b7613f23664efc"
    sha256 cellar: :any,                 x86_64_linux:  "23ff83fac2b4019db15252ab61a80deae5a9bab9e8996d9754baa5cae66440da"
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
