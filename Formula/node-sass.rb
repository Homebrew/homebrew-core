class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.8.tgz"
  sha256 "aaf64c25a0efdd231fab1c98b2de31fe0a4b163444383e656077c12412f6736d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d58b344b5a04e6389a1ffece4bf7813148b155a793cdb5aff7c431699bfd6cf1" => :catalina
    sha256 "3f70fe6fc85d07467f9a030c78974ceb1a2732d3408012991784007d9b851607" => :mojave
    sha256 "6e85a4bb7e5dfbd68ac1ae4ca48ffe2770a167f38cc19d8f723a2560fba12d29" => :high_sierra
  end

  depends_on "node"

  # waiting for pull request at #47438
  # conflicts_with "dart-sass", :because => "both install a `sass` binary"

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
