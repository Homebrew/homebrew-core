class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "a5ed312d5b516a1b085c5fe8fda4e3c2153b9c4d397f7067eb721577a29e48a2"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a65a83e148603628312018e5d8d8e81ca71ae7e5eb1982d943a82960d2313c09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e8b917706f82bf59d25469a04d95012e73d82fe62d365aba1be4d175595b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef84853c93c5c1c1c56093462232ac4b22037a59df225f0ff4ea0fa44df76d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8941e03984f9ddfdf9e1e8b06a22e6249f151ebc02a2179b7b11ac2aaf3877b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eb674f01d27a36f544e315376d54fdeba307c7bff7176885ebf947236868cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0862f7c5025150525b765da495a8f50205ab467b248f9410e6ca7b9ac6dfc133"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "install", *std_npm_args(prefix: false), "--ignore-scripts"
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
