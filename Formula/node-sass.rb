class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.23.7.tgz"
  sha256 "6113e3c3034a8d7701c9ecc73e7c2f53e6e419a47d42a63e26ac4546a878328e"

  bottle do
    cellar :any_skip_relocation
    sha256 "322346ee7f6719fc0697d8c9e5b5209e0169dde870ec9c7ae71fcadb26410797" => :catalina
    sha256 "a6536baf69cfe20e40be7109e947b008e64b32534e617a4315bc6404e4520478" => :mojave
    sha256 "ee3a08eb743459e18456808f98f230e779fd72f62716c881fd35da5131e36302" => :high_sierra
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
