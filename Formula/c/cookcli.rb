class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://github.com/cooklang/cookcli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "d3f6dea0429034c35107f8584e63f29c6f90b8a69ee5fa92cd7de623e573bb4b"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a84af0078a0b1247bd70c3bbb8c17512d8f4b3dfa49932f7f694f87976af73f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0117136d173111a4539459edfffb9c117f9620897ea513ae7563ed4181eac3ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc72ecac5816a50894f107f5b5a4394b3d32ca4ab7e7bdcdcbabae3cfac13127"
    sha256 cellar: :any_skip_relocation, sonoma:        "af9a8e94caaad375003c7030544e18c3aae7556c2329a315eea8cdf7ddd08ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a36ff0611168556da1317bc530bba5900b866f3206055d4136c120b090d13f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "191d1110ad5054935e74c7a5491133edcc98824774ad4413152a9f1fdf22ceb5"
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
