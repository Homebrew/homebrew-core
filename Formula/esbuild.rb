require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.14.tgz"
  sha256 "d388e6e7d209efe03ee128294b919e2ac5e9f8873e1d187c9bff596b8e9783eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4b465d30102ea985ed62b92308660940e579bb344ccebc204b384d9045f985"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a4b465d30102ea985ed62b92308660940e579bb344ccebc204b384d9045f985"
    sha256 cellar: :any_skip_relocation, monterey:       "e2a8440e4826ae0fbba3c844c13b3455298ebbaffd9cb7125d1cae95ce72ca10"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2a8440e4826ae0fbba3c844c13b3455298ebbaffd9cb7125d1cae95ce72ca10"
    sha256 cellar: :any_skip_relocation, catalina:       "e2a8440e4826ae0fbba3c844c13b3455298ebbaffd9cb7125d1cae95ce72ca10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a666c30a5b74181715de5c304b07d80612f53d0e8d8b184c6ea0f3c596554025"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1 data-reactroot=\"\">Hello, world!</h1>\n", shell_output("node out.js")
  end
end
