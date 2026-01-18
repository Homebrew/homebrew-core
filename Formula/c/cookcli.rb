class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "579c118763add741070c358966de7175d2a13b353cf97bacddcc1fa1dd6f3e6b"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1630b22e5d7769e6c22143028540fc4ca093f297be620a63af0168cc70905a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0012cebdbd2e1d37e549a1d7d8a5d37e9b3d888f9854f9f1c4ccd85aa418d04c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c85960d09cb7490a590f4fdc73dddb3b8f8ea38c77d328ec54cdb014d57f8e37"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e2c3709a4387b7363baca8cc27415962c70b2c4f82bcc4324c96f05b58921f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7073a30af652451cf0a69661a8986bae5194c15519fbff684a1ab7a60ab2cff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542c77e561ebc137f434f82b8416f903179ac33635e57c8273ee93cce385f4a3"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build-css"

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
