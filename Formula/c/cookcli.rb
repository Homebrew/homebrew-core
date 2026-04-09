class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "362a90be2860dcb9bf4928197f5fd278eb2f44c1d039807f31998616832379f6"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b9a41a1ada368904d11aba402d8c65925d839ec3649d3924fb1f775de3f3be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95841f0bced32ea34d5caad6754c0b8ce8d1b08b0d2216b5dcca3c0c5505b3ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab740b37c9eccf25fbcb049f29bd3cc910fa2542487bb7696b13262295991896"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7dee3f5a1d421445248757f712bd416a7c88f091a047bdffb9ec5fc5eb5b059"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cbc4c1c4ffcf0bf9d72d8a5109de875e569126c2f078d3ec875463235f61e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3910987928f6ea2136c759137450aa02761e6303d3d5de8c6c398ab6f123760"
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
