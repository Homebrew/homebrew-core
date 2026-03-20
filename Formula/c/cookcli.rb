class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "e354fc6235848ca0453c847b4590120f8a7828c703a83e8eb62434d8cc7467cd"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06717611403c341717fe0c15488c4788b22451a9960890ccaa5f6dd4392f06a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18ebc479f92b9772b81a14f9b912692224b5961001e67397e7da748bfd4e0622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94d418efb1c24b302af4897126adfac292734eb7eadcb6dc6f900266595a014"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e7ade9256daf86dc2b32665ee5f1d4dca9b3542f110608b4afd93a656bd716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca16c47072b9a548bf9641a36ec1ba84c3832699febbb8fc22b3b223354d1aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c81fb52a5e6702f4335a48dfa29a52e53272a8a18f55ad21cdbca619a316cd9"
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
