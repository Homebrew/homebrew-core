require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.11.tgz"
  sha256 "339ee55c89ed051353fc37a6d188ed4da6974df65d2f4b23c21628a5a50d7318"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "155430f0373a73d0fd0d893301ceb405db8db51c72a781b9f33e9ad6a57440c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "155430f0373a73d0fd0d893301ceb405db8db51c72a781b9f33e9ad6a57440c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "155430f0373a73d0fd0d893301ceb405db8db51c72a781b9f33e9ad6a57440c8"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f9c9406b3b23d453de36abbc02167db79147155d2bafbbdd0d62657741df82"
    sha256 cellar: :any_skip_relocation, monterey:       "e6f9c9406b3b23d453de36abbc02167db79147155d2bafbbdd0d62657741df82"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6f9c9406b3b23d453de36abbc02167db79147155d2bafbbdd0d62657741df82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf775b2e08459a43bff641dc6f14298c5ceff0148f9e0fb3bab00398c6f53aad"
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
