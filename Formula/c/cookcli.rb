class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "20e7b60eb5d0a98ba182d8fadc6e95d70d99c9935a391313e532fa5f6619bff8"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8828756df8f300cf9426ac1c5b6f59c5e2c68bfdfc40d1be32dc8e13428c195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75a3e91bd01a66683e385483897edfad096ec9711aed8dbc76aa2ee5fe0dc8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a2e34519e3e0c9af4a58fa31869662c7a7056c16874b2432b6e76541b479fa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab43a54331607f10bdc248620f56ffebae33a39f4cf31b4601c9520bc83dba6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a4199d7452568e166fc3e120a299223768cd34e6f2718e5aa7f31268e35f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37364317e295a0c985d9b696137bf6bd5dc7945ab8bab7e47e8cf3135549553e"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
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
