class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.10.tgz"
  sha256 "c4eaec5fce24d37920d9b537df3e699fcf356981193695eb000115b03f56be5f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "12168b49fff68e0dd1b80baddfedae78f87285fef8377ecab846d0c00c60e3e1" => :catalina
    sha256 "4ccd800040beb3b50ed40d4a1ca308b2343265ee03dfa87e3febc0685285120c" => :mojave
    sha256 "9c003f625be9dac77603b56a37a462f49dc96558e557ab4485b408c2ce4074a7" => :high_sierra
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
