require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.11.tgz"
  sha256 "7b52afdf60700d37a0491a5faf03bd8b795da00fd63a8bd52d7f5534e16e9948"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d4d7bf33bcdb8fd5a765ddea67dd00c477f631eaa4b7872387634605166f48c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d4d7bf33bcdb8fd5a765ddea67dd00c477f631eaa4b7872387634605166f48c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4d7bf33bcdb8fd5a765ddea67dd00c477f631eaa4b7872387634605166f48c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c29eb828cd51f15dd6512247f1e92e3d07b1ba8a3a324edfa2da7ff6352ce6b5"
    sha256 cellar: :any_skip_relocation, ventura:        "c29eb828cd51f15dd6512247f1e92e3d07b1ba8a3a324edfa2da7ff6352ce6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "c29eb828cd51f15dd6512247f1e92e3d07b1ba8a3a324edfa2da7ff6352ce6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ab00f25ceb4c0bd23d55a318173aeecfae9ec8d5c9139bd92fa280d5d5a49a"
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
