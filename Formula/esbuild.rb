require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.0.tgz"
  sha256 "1ac6ff19a3b4416f84f0266cf7ff4a1b9654a6e3e63208ef40ae6d51e03c8578"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8838055a6be0f52a0a9393bf1e0740c7c4774d64f94b15d66ef8e8b00f0af048"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8838055a6be0f52a0a9393bf1e0740c7c4774d64f94b15d66ef8e8b00f0af048"
    sha256 cellar: :any_skip_relocation, monterey:       "b968e55813a34836d4b216cdd0f0a1af4bfd092ff522cc6852de56bd8d14fa62"
    sha256 cellar: :any_skip_relocation, big_sur:        "b968e55813a34836d4b216cdd0f0a1af4bfd092ff522cc6852de56bd8d14fa62"
    sha256 cellar: :any_skip_relocation, catalina:       "b968e55813a34836d4b216cdd0f0a1af4bfd092ff522cc6852de56bd8d14fa62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3119f8ec20bd221e665a5872fb78723364901c56a4ffa47eb0935a8c3ece720"
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
