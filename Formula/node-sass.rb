class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.52.1.tgz"
  sha256 "d955542fd7d777c558662c0078b042e5dca3ada87e54592284eeb212ee2da148"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0191dd83034a1e0be1b429614d90a4b4be5abd22efbb14fbe6e91eb2941ebe12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0191dd83034a1e0be1b429614d90a4b4be5abd22efbb14fbe6e91eb2941ebe12"
    sha256 cellar: :any_skip_relocation, monterey:       "0191dd83034a1e0be1b429614d90a4b4be5abd22efbb14fbe6e91eb2941ebe12"
    sha256 cellar: :any_skip_relocation, big_sur:        "0191dd83034a1e0be1b429614d90a4b4be5abd22efbb14fbe6e91eb2941ebe12"
    sha256 cellar: :any_skip_relocation, catalina:       "0191dd83034a1e0be1b429614d90a4b4be5abd22efbb14fbe6e91eb2941ebe12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d65e4e4f959d773594102bd7bb43efbaf437e3213db194a3ba9a283eaa9c73ac"
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
