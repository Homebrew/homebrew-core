class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "0540836a4984d22ca4c55b6d0679f8ba80877dba92a13e63d1751d264c4b6f40"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f7d99e89ee329061ba107cc6c609fb0833ea9b8842aab3e4a3899e001ce67ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10299133bb048f38c58f80abb45ec201ee6aa17d66a80186808d81c708683e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90931dcb93991d98473ac2d597161908cfbddb32e2941b5802116dcbb56fd27c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab1da8ef2b3498363354078bc3aaedaf73f9893a88acb36d338a66f902d7197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8599d3eaeab8a486e5d01acc16f16af1baf6172236bf021243ac29f9d23764fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "127baf69f114c032ce4300ed2af697ee80e3e9db5ee735ca696cf780d6ae1816"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
