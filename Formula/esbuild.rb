require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.28.tgz"
  sha256 "ec1e8d5f6e78970fb521fde9ceebf7ab1ef0b92a74722db468e92d5b262b0c73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "791decba73a40c25234a4572d3fa4464c1aae3ba13bfcfb30ca95092950b548d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "791decba73a40c25234a4572d3fa4464c1aae3ba13bfcfb30ca95092950b548d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a285db85fef61ff575617b0a27d01a53abe36783e18e08936a30da23416716a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a285db85fef61ff575617b0a27d01a53abe36783e18e08936a30da23416716a"
    sha256 cellar: :any_skip_relocation, catalina:       "6a285db85fef61ff575617b0a27d01a53abe36783e18e08936a30da23416716a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0a35a99130c47daedfe2c203dbea0ad391d210ee1688ed123b5ea071644225"
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
