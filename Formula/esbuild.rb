require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.17.tgz"
  sha256 "d4aacaef7d1015e49c4643d9e55469de4e05305f0445e69e91f133526ed74f03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "895612da561b6112069034a2243018d7788cff7826a688f28e8c12f874bb2b11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "895612da561b6112069034a2243018d7788cff7826a688f28e8c12f874bb2b11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "895612da561b6112069034a2243018d7788cff7826a688f28e8c12f874bb2b11"
    sha256 cellar: :any_skip_relocation, ventura:        "fb16450168ed32737349702d2c606c8594678c019b09e6b6f68c3f38ac18e966"
    sha256 cellar: :any_skip_relocation, monterey:       "fb16450168ed32737349702d2c606c8594678c019b09e6b6f68c3f38ac18e966"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb16450168ed32737349702d2c606c8594678c019b09e6b6f68c3f38ac18e966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7230c7d7935648c75e9a88cc0e2653a8623c1a02e941e30c0fe93835810455"
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
