class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.4.tgz"
  sha256 "984284c0d133a126e20a14fe60982fc4dbb1b97e008e637d2e03bd645973ca9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab4bbbe0462b29b97b3bd18ccd9d1c8c6b796e9b042a863b2df134055dfaa11e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab4bbbe0462b29b97b3bd18ccd9d1c8c6b796e9b042a863b2df134055dfaa11e"
    sha256 cellar: :any_skip_relocation, monterey:       "ab4bbbe0462b29b97b3bd18ccd9d1c8c6b796e9b042a863b2df134055dfaa11e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab4bbbe0462b29b97b3bd18ccd9d1c8c6b796e9b042a863b2df134055dfaa11e"
    sha256 cellar: :any_skip_relocation, catalina:       "ab4bbbe0462b29b97b3bd18ccd9d1c8c6b796e9b042a863b2df134055dfaa11e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819f3aa282d8e3b9c95f1a3e3e1aa7570d8c5aeaf3032ea0a083c83538552b58"
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
