class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "9a44b378b7e09e6e41a829e2bfd666f4da1809b281501fe5a2ea14851a01a338"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0269f50e5b7ca22272dc340a05bc2e601d76447deff7497904ab6644ffc6be3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8135cd1eb9bb656139279e2ee54eee6bfe07c6a800ea9e90aa64eb3013a0f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b491ea1202807f52a385115c1266f7f5c59b080c16d361d07b64788e9e6e967"
    sha256 cellar: :any_skip_relocation, sonoma:        "71215553f9fd4adbc704f0130c9983505d2dd2ca8fe10bc733827c23b2e89a6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2273908070259c1ab3b4dbe7511ea090bf5ee76d5f994921c063a7400a789adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b989d88f6908530b7e135b46f0aeaf2d6149aca05df54e6fbfbd444b1bc1904"
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
