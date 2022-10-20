class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.55.0.tgz"
  sha256 "03c9249d830e089d8d8a281162771a1c77beac50285c603b4c729d246a13dce9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2da339f365082cd3e9f40c7a531f395f84958bfe30b1f4d3d7a39417a3741db7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da339f365082cd3e9f40c7a531f395f84958bfe30b1f4d3d7a39417a3741db7"
    sha256 cellar: :any_skip_relocation, monterey:       "2da339f365082cd3e9f40c7a531f395f84958bfe30b1f4d3d7a39417a3741db7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2da339f365082cd3e9f40c7a531f395f84958bfe30b1f4d3d7a39417a3741db7"
    sha256 cellar: :any_skip_relocation, catalina:       "2da339f365082cd3e9f40c7a531f395f84958bfe30b1f4d3d7a39417a3741db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d35718c8e8acb1ddbc0f31cb86dbbbfa638a70f55f014ebba77fa3ee9ac6050c"
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
