class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.79.5.tgz"
  sha256 "0c343e22843acc027d644ccb184d287d0109b00b3889d3eb5d30695eac1e2ec0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d7b343b6498d35f14b8efb6647b60b350887049b28c0239e4615c3d2d559ffc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
