require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.11.tgz"
  sha256 "c47bb57664b8b61acc872302d6e1125b0145a2c5ef1776bf57c736e78ecf0280"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15cfc0f5bc6b709e9248dd60a274a2df58f9bb92be32f53fc99e2ccc264606d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d15cfc0f5bc6b709e9248dd60a274a2df58f9bb92be32f53fc99e2ccc264606d"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a3b9e79fd082a00d590b324356bfeddc672a3f7c3c9afe364f582c1ae0dc25"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4a3b9e79fd082a00d590b324356bfeddc672a3f7c3c9afe364f582c1ae0dc25"
    sha256 cellar: :any_skip_relocation, catalina:       "d4a3b9e79fd082a00d590b324356bfeddc672a3f7c3c9afe364f582c1ae0dc25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d24c9fa7ea73c5f5fa0e2ef48422f8e2af80bb797810d1c70d49cddf3652017f"
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
