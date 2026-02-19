class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "1c978015c0cf1ae424d7e329a8fd54e9efed2509cd500507ee9b13876aa60456"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73a03abdeaf23d6fa086af6c94425a43148a856f2bf6d6c9caa63018024bc08e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e6c03c86c4ba6ec54c5c3b491d6496bcd8c02dd82a13ae15f516b818b36bc73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b5a0066a643bf98623869a538c9c901c35f4b23c402cc6047c42b183376c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce5b442233e1344f4dda76848baa90528658174f60740a406c68eb95e1b7821a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9497043f7247046ec0efeb79e348d43395a8983f8df24b6088ae8db9f88522cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06329716684057c53475e1e32c969da5b8d9d0642fd23783a8f3407d140d38b"
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
