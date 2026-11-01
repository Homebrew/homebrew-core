class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.107.1.tgz"
  sha256 "e983e8e3ecfa2d15fc67ae0aa613a68aecc27c30cfa141b1fb1b7ca07a288faa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ae712760a1f2c2cb27cf08ce2d83fffb5d4d23cde58eae7bbb5eb9239510528"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ae712760a1f2c2cb27cf08ce2d83fffb5d4d23cde58eae7bbb5eb9239510528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ae712760a1f2c2cb27cf08ce2d83fffb5d4d23cde58eae7bbb5eb9239510528"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de17ee15b2d4d33547526cc55a8df77d5478ea459b4e4b11c04fc0557979ed72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "726160ba8ec68ed1f75e09a7cdfb7e1c4ec0016d068215c617cf8deb8e5545e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
