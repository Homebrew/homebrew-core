class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "05cb33e3665b05aed28730d8676b875cc2e6ef825689f21b468a4ffc13bfb801"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5787da8e34447921294044fd847e7c3dab6a610927f2d969bd3b3f26c7e572e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef64797f8e9449eb7fb187263b2226dc76c621c9613605cc01f9efae560a03d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3722ef48375f7580ee7b224390998a6cc579142e404d199e4287eb4ae9258aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "68caf7b9b0b6fb06be676d7998a6228389765e390809d8eed03dac8ee06592d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed714379c494d3321c1b9439afb664f0eae31c8ef201a5cfa7c25b1beff2465f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "becd7c59c54ab9e2b441a78908f0c51d3a4b71f746afe1a67494030c4f3e31bf"
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
