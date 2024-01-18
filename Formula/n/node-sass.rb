class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.70.0.tgz"
  sha256 "4def4fbf34429d597b80b15178e27510d31017d8b2cdac1dc82f5aaf177967ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b474aaa6e48bb507c827e51d1198386276c9b34514a5c5b861b469464a7d66f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b474aaa6e48bb507c827e51d1198386276c9b34514a5c5b861b469464a7d66f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b474aaa6e48bb507c827e51d1198386276c9b34514a5c5b861b469464a7d66f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b474aaa6e48bb507c827e51d1198386276c9b34514a5c5b861b469464a7d66f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b474aaa6e48bb507c827e51d1198386276c9b34514a5c5b861b469464a7d66f7"
    sha256 cellar: :any_skip_relocation, monterey:       "b474aaa6e48bb507c827e51d1198386276c9b34514a5c5b861b469464a7d66f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "288901d763a9ca2f28991a9de1eb73228e62011468a845c8d0c04cc2ab403fa2"
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
