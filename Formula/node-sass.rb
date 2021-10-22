class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.43.3.tgz"
  sha256 "3a9be570a52b12b7f0505855074a43ae7e543d0abbe78e36c169230a35ff54d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d714f7d866aafce39843fe82126018427adabda2cf503ce6461301920567b3d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d714f7d866aafce39843fe82126018427adabda2cf503ce6461301920567b3d8"
    sha256 cellar: :any_skip_relocation, catalina:      "d714f7d866aafce39843fe82126018427adabda2cf503ce6461301920567b3d8"
    sha256 cellar: :any_skip_relocation, mojave:        "d714f7d866aafce39843fe82126018427adabda2cf503ce6461301920567b3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4adce5f343de942076129edfef4d3884d6a7af68f75cafe932f30bf3dbcb0d9f"
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
