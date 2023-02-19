require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.9.tgz"
  sha256 "99e7e4709523ab155a3468c829d1517685cdb2b6356cde50b188dbf8ca3172cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ee80515e27bc21f6d174e4cc7ed0196028ed994f294b4252235444585336afe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ee80515e27bc21f6d174e4cc7ed0196028ed994f294b4252235444585336afe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ee80515e27bc21f6d174e4cc7ed0196028ed994f294b4252235444585336afe"
    sha256 cellar: :any_skip_relocation, ventura:        "cd434b4d87b695f69270b88ef900f2dc5026203662e1aec4e02983c45b1601e6"
    sha256 cellar: :any_skip_relocation, monterey:       "cd434b4d87b695f69270b88ef900f2dc5026203662e1aec4e02983c45b1601e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd434b4d87b695f69270b88ef900f2dc5026203662e1aec4e02983c45b1601e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11d74ac93c720fe89fb353c9a0bd586e30544ed7cece76d17bdc1808ee87c7c5"
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
