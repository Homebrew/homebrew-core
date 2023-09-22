class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.68.0.tgz"
  sha256 "5d56141989af50167513a32958a4da16158f6b569e8db1025debdd2b34a8c440"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3924058e06160f7c5561b6b8a7a40569c6b2a92427650f978c6f79cee19e2074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3924058e06160f7c5561b6b8a7a40569c6b2a92427650f978c6f79cee19e2074"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3924058e06160f7c5561b6b8a7a40569c6b2a92427650f978c6f79cee19e2074"
    sha256 cellar: :any_skip_relocation, ventura:        "3924058e06160f7c5561b6b8a7a40569c6b2a92427650f978c6f79cee19e2074"
    sha256 cellar: :any_skip_relocation, monterey:       "3924058e06160f7c5561b6b8a7a40569c6b2a92427650f978c6f79cee19e2074"
    sha256 cellar: :any_skip_relocation, big_sur:        "3924058e06160f7c5561b6b8a7a40569c6b2a92427650f978c6f79cee19e2074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2cedc4dc837413fa58fab32a5aef7b8d3d6fc3f5880b9b5632050abca1a010d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
