require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.17.tgz"
  sha256 "5db47446105f2f40990d3e88668a3fa438d2a794eae39fa5e9a2351f7ae437c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28afe47a2ab116612f9f806afc0f8570567009497ef81a56f0338e4b93ef7ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28afe47a2ab116612f9f806afc0f8570567009497ef81a56f0338e4b93ef7ad2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28afe47a2ab116612f9f806afc0f8570567009497ef81a56f0338e4b93ef7ad2"
    sha256 cellar: :any_skip_relocation, ventura:        "1ca3187ecd8428576bc395aaa10668087599dab6a692d07878ed6ddefad27991"
    sha256 cellar: :any_skip_relocation, monterey:       "1ca3187ecd8428576bc395aaa10668087599dab6a692d07878ed6ddefad27991"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ca3187ecd8428576bc395aaa10668087599dab6a692d07878ed6ddefad27991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a844e9316f68031bdbb6c30c72a4abc2cb41ef88bc73b83ddeb63fa3cfa352e"
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

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
