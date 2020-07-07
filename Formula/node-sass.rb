class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.10.tgz"
  sha256 "c4eaec5fce24d37920d9b537df3e699fcf356981193695eb000115b03f56be5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d537d2b694e096afcd4a60d5ad23c14eecb947622a57b68bf8711a5376e9ebdf" => :catalina
    sha256 "5aa46ab77bb306f631759a1cfd502191e8071e3ab4fd3253431dbdd3a03379f1" => :mojave
    sha256 "4fbb3afabbb12ae7bc1cc3c536e48992e67941f803c5eb510dbc9f0c796f2d17" => :high_sierra
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
