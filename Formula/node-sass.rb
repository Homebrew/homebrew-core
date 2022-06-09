class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.52.3.tgz"
  sha256 "e064b7f3c8b0a7202c2d8ae5890a8a22cf243510f2fe0968a8e78b73150079f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d4e26ce05a9ec7af33c1fcd016a9cb900557bd899acb5f0b77752e39b2fcb4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d4e26ce05a9ec7af33c1fcd016a9cb900557bd899acb5f0b77752e39b2fcb4d"
    sha256 cellar: :any_skip_relocation, monterey:       "1d4e26ce05a9ec7af33c1fcd016a9cb900557bd899acb5f0b77752e39b2fcb4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d4e26ce05a9ec7af33c1fcd016a9cb900557bd899acb5f0b77752e39b2fcb4d"
    sha256 cellar: :any_skip_relocation, catalina:       "1d4e26ce05a9ec7af33c1fcd016a9cb900557bd899acb5f0b77752e39b2fcb4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b0330df1b7f9ebf7e6ad890c1ef66ea148ac121328e7fc31d423871cab98ef"
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
