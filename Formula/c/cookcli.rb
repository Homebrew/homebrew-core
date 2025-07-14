class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "b4a52440e2ff2d1fc53206ff65993ccc29ed5d043f29be7d0bc1e07f6663824b"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b083f53dc4c290a7055c352cff7f85a4610ae6b05ad1214d02ed4b7c56243f59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9625e0e5854ccd5adbbf8ca62f6a4a3158fdd91d191ff91bb006b4301bab43f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eee813fb8bdad06c73c4ef5801f4cacca39391ebad33464792a6505ddb40a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b5122e8b0cd4d95e2569ef6af741f505b22469d64a4f55fd71510f3d187609a"
    sha256 cellar: :any_skip_relocation, ventura:       "c926faae58e4a26a2cfc9d37155ee5a1d08be05c221e3747334dc128ce0808d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73f84a7ca8b52b80ff8078dbd81ffdb890009d67913dd3ecdbe234a7c0fbe674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69650675f7612fa932839e5a9674c8c9812beb1c72492815f3467d8de35e186"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
