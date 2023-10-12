class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.3.tgz"
  sha256 "6877924bede69b9f2f51fa178625181adfa6c8cf7d28d11d180713d4bf371a06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, ventura:        "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, monterey:       "e014f99baa14ce08be230f5e8430d5604debd29b03cbb39cee3e51e47115472a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57cfde8b7d7d8bdcb72773a1bf72651c3633fe8802689b3354968fcbb14b42d"
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
