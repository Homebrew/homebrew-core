class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.101.3.tgz"
  sha256 "3880ee9c7e58872ec987f258c2cfceb1ac8a4220522669b2a3ca9e9ff6910e88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "122d37f41770b69c85c10159ed0950b01f85f704512c2dc70121d2af79d3ca8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "122d37f41770b69c85c10159ed0950b01f85f704512c2dc70121d2af79d3ca8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "122d37f41770b69c85c10159ed0950b01f85f704512c2dc70121d2af79d3ca8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "59e75911d9992e18eed506eacee4750a45c51c32f241f2cefd9d01d64c9eb604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15e302d00aef8fe3fb0e2a71ad203107da58817ad5f504457859caf1077aa264"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33b18e0ff61462a304dcd9446d5b5074027358cf0a176a9693a000b1be063d0c"
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
