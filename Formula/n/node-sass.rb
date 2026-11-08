class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.108.1.tgz"
  sha256 "7239b5374233970a049c51af7175dd3842e708c69cd6716771111c2d164f7d15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76fcd652ec5e494d59c70cce6380d486ed22850d8c52d5e0d1159bc47a37440c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76fcd652ec5e494d59c70cce6380d486ed22850d8c52d5e0d1159bc47a37440c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76fcd652ec5e494d59c70cce6380d486ed22850d8c52d5e0d1159bc47a37440c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b692468263a5e63cc6c19605bffc7f9dfd78a0729ca238168c6df9653f4f0176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "450049085c7d53af15cf1f25c7d53d0304f6b101ddfa40972cd3e3a78d5c10d4"
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
