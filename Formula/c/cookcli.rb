class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "00ee36f1ece86890ff2698b1a9d2a736f3500466879f57a073b62beed31379b5"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99eb168fb0f24e936cc3c4f76123e7a965fafca79cd46577484ff7b41ab7425a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d946934fd0e9e3900e65003a2358c6a83b7ac50f4d64b228f55afad60409732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee3fd846b6259c9d98591356627c27ff1289752c0cf2c0d50c69b055f0543cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1210a744226b5d8a1c3ee845fff148b44ad3f43453d14aa2e70a19d0d3f27cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd324509be570513f99b7fd7612fca78f9fb6174672fa1fe3ea55887b3297f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa0f606df53567658253934322d581095af09b97572d5e1a7e4e9c48d97db52f"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "ci", "--ignore-scripts"
    system "npm", "run", "build-css"

    # Build and install the binary
    system "cargo", "install", *std_cargo_args

    # Copy static assets to the installation directory
    pkgshare.install "static"
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
