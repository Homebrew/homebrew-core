class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "f8798fb956ea609194bdeddd02ed23db6d76a7f9b94b90c6a567ff4ae65d58d8"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eca67bac9e88ca5d9cf36cca45c3bb3eba55b456cb6f2eadd17f21d2858955b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1831391eb0a44fff305b52e1eb8b9782bb1e7451532027540e0f2a1c21514ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d0711cbc309fff541bd1470a103d3c9f65e017a7a6feacdd6a525c2a0a5f93"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fefbcc82e5184d51a67f7a502b8b410fb7faf6940ca25c38c4f80ec3a993f83"
    sha256 cellar: :any,                 arm64_linux:   "929a058e1decccdb8d6aae3a62226544f68493c6c2d4d34fee9b0581d0183b78"
    sha256 cellar: :any,                 x86_64_linux:  "435853887d43a786aa96f4ab5f648c6d7ff105d908d266926cbac318c593f114"
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
