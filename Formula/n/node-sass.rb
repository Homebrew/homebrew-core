class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.108.2.tgz"
  sha256 "a3398fa194c3379174bac6650bdaad077d1fbe71c4e58e817b2e213d1479bbfe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1b408f58a58a335533eb34281096b00fc312c9f6eff3adda61697aeee5ebb05"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1b408f58a58a335533eb34281096b00fc312c9f6eff3adda61697aeee5ebb05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1b408f58a58a335533eb34281096b00fc312c9f6eff3adda61697aeee5ebb05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "74f62a40156b30dd43d3aadd7c4e46ef2c300aa11cc23ea7a9bfc6dbfde1ca37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "726401a21f98721530b79281dc11557e00daf84b109e5c6b9aead6584889f54f"
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
