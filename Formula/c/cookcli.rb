class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "233f3a349c21936d89eca66daf9e61009dff745fbeabf1fb591c5e33dccabe0e"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "00e150ffb91816fb41e90ba28c2414f1b77802c62364a90b741115b96d3a96f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f58a3724f5338f5d2c5a0b1645b73570d58f983eb2b83247eae63b58eb539a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38a9160d0d5528c0be094c31e82e891fc8ad31c3d2a6e3e99d729a2fae2e4abf"
    sha256 cellar: :any,                 arm64_linux:       "16da31d077498fa953da97a98a745ef7292bef9b2b6acddf63803b98450ff92c"
    sha256 cellar: :any,                 x86_64_linux:      "2cd317d0e96cf2d11a8ff1831de9747cc52bd4aab956d62b2f61b3a080f52f3d"
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
