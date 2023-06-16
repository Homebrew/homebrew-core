require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.3.tgz"
  sha256 "048252e9c90d6ef973e6e7a640f9a1ad9172180661b5fb3ed8178587aabbd5c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d293e6b07b18f8ec926fc579298184471d00dda71b0d8ed90a04d603c6ceddf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d293e6b07b18f8ec926fc579298184471d00dda71b0d8ed90a04d603c6ceddf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d293e6b07b18f8ec926fc579298184471d00dda71b0d8ed90a04d603c6ceddf7"
    sha256 cellar: :any_skip_relocation, ventura:        "1e9f17c66e7cb91c6520ff62365b55b761e5e8f821f75f4990c01cf33f448145"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9f17c66e7cb91c6520ff62365b55b761e5e8f821f75f4990c01cf33f448145"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e9f17c66e7cb91c6520ff62365b55b761e5e8f821f75f4990c01cf33f448145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9c1fe44c5cf0dca69d4c770c79d0bc393a31b906f7c97d0253c6c15227f759"
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
