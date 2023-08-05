require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.18.tgz"
  sha256 "b3743d34028f672f81fb37ef192384e33a797f7394d77cb2d8db40fb525de826"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3c7dd4ae2d74966a54191d5fb4c8bc5d3e0b0ef92d5ff296e3ba74b0bd8977a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c7dd4ae2d74966a54191d5fb4c8bc5d3e0b0ef92d5ff296e3ba74b0bd8977a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3c7dd4ae2d74966a54191d5fb4c8bc5d3e0b0ef92d5ff296e3ba74b0bd8977a"
    sha256 cellar: :any_skip_relocation, ventura:        "258b4eaf04c3f2d09729fb9e4c3995e943c4d057fa8fcf9d6ef3cb04aa74b476"
    sha256 cellar: :any_skip_relocation, monterey:       "258b4eaf04c3f2d09729fb9e4c3995e943c4d057fa8fcf9d6ef3cb04aa74b476"
    sha256 cellar: :any_skip_relocation, big_sur:        "258b4eaf04c3f2d09729fb9e4c3995e943c4d057fa8fcf9d6ef3cb04aa74b476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda87a06497a9a48bfc088c7e489232399f988b7d75d4794ac2327ec40f19abc"
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
