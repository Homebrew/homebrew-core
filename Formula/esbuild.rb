require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.12.tgz"
  sha256 "5f131af1aad00544fc1b2daec87fd2cad6752ef2d5d32d8079f573a68abccdb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36582088f5a08586466d566c1c7ca3c0e7c85d37a4f6c615f649592c62fa18ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36582088f5a08586466d566c1c7ca3c0e7c85d37a4f6c615f649592c62fa18ec"
    sha256 cellar: :any_skip_relocation, monterey:       "5637a3b0e5f25fcaa1a32c28e91bd7f8adfd0c1961f00ce2bb4fdbb4a870fe17"
    sha256 cellar: :any_skip_relocation, big_sur:        "5637a3b0e5f25fcaa1a32c28e91bd7f8adfd0c1961f00ce2bb4fdbb4a870fe17"
    sha256 cellar: :any_skip_relocation, catalina:       "5637a3b0e5f25fcaa1a32c28e91bd7f8adfd0c1961f00ce2bb4fdbb4a870fe17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bae71c300adce98cc89331717941aaa226420fd78ef8a8dde4fd5adf2172403c"
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
