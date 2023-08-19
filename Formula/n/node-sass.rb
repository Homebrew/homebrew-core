class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.66.1.tgz"
  sha256 "c5712f0c9713b25c869d8c4971d1ef60ef193fcc89f5081cc5b124526991d0bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5665d18d9af28a692709167024503218ac0cb96b439fb9088a200fedfa04192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5665d18d9af28a692709167024503218ac0cb96b439fb9088a200fedfa04192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5665d18d9af28a692709167024503218ac0cb96b439fb9088a200fedfa04192"
    sha256 cellar: :any_skip_relocation, ventura:        "a5665d18d9af28a692709167024503218ac0cb96b439fb9088a200fedfa04192"
    sha256 cellar: :any_skip_relocation, monterey:       "a5665d18d9af28a692709167024503218ac0cb96b439fb9088a200fedfa04192"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5665d18d9af28a692709167024503218ac0cb96b439fb9088a200fedfa04192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a569bcd958a2b18b71a24163779e2e8739f8c5e62c36d0469b7fa12d98024d"
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
