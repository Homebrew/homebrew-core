class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "f70561251d0cd29e36e4931320f4bb1c58cdbaf0fae1a13af8b2859c7e36fc41"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e409690bfd9c8fbe9799f97f799a1f91517fc0e29235d3e055959017c4f888c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc258d3a8dbf550feb86a07fcf39b0cc69cadbec19b6b214739693ba2ea282df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d61ad89fe8aeb85b489c8feaf932011ee057b85af815538b0b11d262273865"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3da990beecb7b7dc16892e350ae5fb9e98f60b8f6999f8622522b3b5ab8d4e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7443ee102078360856139efc42739c12275b635fc7d362ed98e184361fa63ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d287507e7b6833d1678a9d5006d2f090a4beafa0b4279a742c9bd68299da7d5e"
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
