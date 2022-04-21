require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.38.tgz"
  sha256 "8f2b2f038089c81eb2f52b1b6062b1b39cb7b93ed962069f4d3c70c899857b5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f3197d9e239e680edd2c4637df363f0fd5efdc96c91cd75c9311ac44b18bfc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f3197d9e239e680edd2c4637df363f0fd5efdc96c91cd75c9311ac44b18bfc6"
    sha256 cellar: :any_skip_relocation, monterey:       "e17396e51fd366b9105a58c987132ba0ccc863ef74e497c822f14b85fcb95bb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e17396e51fd366b9105a58c987132ba0ccc863ef74e497c822f14b85fcb95bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "e17396e51fd366b9105a58c987132ba0ccc863ef74e497c822f14b85fcb95bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8bc6222e0010bd09fe85141ab02575959a042ab8786e85f498ebbcfbd95172"
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
