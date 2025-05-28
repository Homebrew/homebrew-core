class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "07711a144586a38cee0e92d8f48e69c003ef7a070e36a1a04b6901d5cdfaeaa3"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dea15c7dd7bf39e59311620ff9f6cac4c86406336c3c0f60e4103488c67d97ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf8543b5a5c40b4b0c31ee20ae48882e3a02727dcc635fed60c527410fca65c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2ff91dafdea562e92375b387ba349801670c7490bf4d00951d000b274da9674"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb94aab8c7b06a240d898d68b8b6fc08221d0e7943e004b3f612c5f8e3ebb08a"
    sha256 cellar: :any_skip_relocation, ventura:       "c8b371dc1bc3d61fcf02327ca94e6502eb18fb65dc5c725da8f47db4e631d111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d364b1c3995eecb60b46b9b9035b23bd56aec7bb399fad3c1dafb5fcc14d172a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c614d19f4a3821ad0fc8fcb6d49e70f723e90d52f99bc508f82a6b5a25ac4a"
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
