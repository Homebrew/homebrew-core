class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.108.0.tgz"
  sha256 "50ef7024cd02458ac5976ee1e0c23e28bb8c2842233ff428d1546085f4f7a97c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36cc4010d9ed2b71a3d4b366a2f3c04eab8844c8d573a5a56edc1953a133e783"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36cc4010d9ed2b71a3d4b366a2f3c04eab8844c8d573a5a56edc1953a133e783"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36cc4010d9ed2b71a3d4b366a2f3c04eab8844c8d573a5a56edc1953a133e783"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85ab4787c4823a5641d3c47d980e4c7d5a830cf26b1001a3721d325bbbe60d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ecf222deb4ec1618ba67aed53632eb31e8f4228f9604a11c93e81cf42e7e1d5c"
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
