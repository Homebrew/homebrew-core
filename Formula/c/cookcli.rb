class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "8c84ab5fb1416bf05793c9cf8f8a9675b313734b43596bbf51842b525cfdbc1f"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8c5c8863786d4b4863d7547200760b1a1200adf3530616f7a4f6bc76bae6386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf2bec7def378fa90a6a94985b6bbcba4f2c6c1b396c33cf383b417ce29c57b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93bc4d4a321bde1eadc0a1838be12e687fa93ee8797d600c48686a7a2eb615f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "32744683dc8c05bab31880628a75073860d8bdbbb52c1844501c4dcbf82b5faa"
    sha256 cellar: :any,                 arm64_linux:   "b2e4186f332edd4ed1d6c9083370b99c5ec5b3ab0de2d0c60ee747305413357f"
    sha256 cellar: :any,                 x86_64_linux:  "70152bb15f66e11d20f043357e9bed8168530970ff3b14e2a7c6a2221c8999fe"
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
