class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "9ef5df91b09e0d5e84d58df84dec902c3c9156b833d97f164ffb1949f0ddb972"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03192619341d745ab3fc497066b960efec22acfd6a30849582368fd68b215d5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9277cf74f422acfa65629cb7328f611c04613c2c927c9876fa8212877fb7141d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bcb0161b749bbb05b0e73510142c9a51c23e2f75177457e8912213c82609b25"
    sha256 cellar: :any_skip_relocation, sonoma:        "310c083604776b035398ef2f70621422538f63f62ffb5c43db145172eca13718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8fd17a80516a0916d8c819b9196607dbeb12ecb34a2c0e5739d8254c45eaea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f92a885635fdad884c8a7b0c7a1b0bbf4bf170bc1352a6305b6f31e789b96e7"
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
