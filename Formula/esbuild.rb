require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.11.tgz"
  sha256 "c47bb57664b8b61acc872302d6e1125b0145a2c5ef1776bf57c736e78ecf0280"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb72c160d6991581f4990cb72a7573b9de6d872aaf5ab9b6cf4eace55eaf747c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb72c160d6991581f4990cb72a7573b9de6d872aaf5ab9b6cf4eace55eaf747c"
    sha256 cellar: :any_skip_relocation, monterey:       "08d58a495f5dd82b8234103a55ea3028629e4567223e973829d8ef4da7854c67"
    sha256 cellar: :any_skip_relocation, big_sur:        "08d58a495f5dd82b8234103a55ea3028629e4567223e973829d8ef4da7854c67"
    sha256 cellar: :any_skip_relocation, catalina:       "08d58a495f5dd82b8234103a55ea3028629e4567223e973829d8ef4da7854c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4a27078f8cafa8c7d030ec76bfa6457501b210428fd22f1648f42e22411d23"
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
