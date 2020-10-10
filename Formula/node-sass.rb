class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.27.0.tgz"
  sha256 "40ffe0c5ebd4f41d814d323f29f3eea5f6bde877ae52a7017a23b740ad096347"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d7a651431570f89f212e8c153dce8075b4ac4d183c4dc576d7560fff8406bf62" => :catalina
    sha256 "1e678719335e1dc69ecb93bc5961011e96ee7d1a8c69a10da3002021e359c56f" => :mojave
    sha256 "3d63493ab2ea2b44711a18252334edb2e5092eb76f648169c0e1e9f161760354" => :high_sierra
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
