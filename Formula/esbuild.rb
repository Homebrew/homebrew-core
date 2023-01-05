require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.14.tgz"
  sha256 "741907c1f867c4e4b5b11e2c9523584dfd7cd288b891b156348f1b258e03f460"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6920acd78a52abe1f72ce052d12552b2cfc7194fa5f0f9fd7690ac4b086821ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6920acd78a52abe1f72ce052d12552b2cfc7194fa5f0f9fd7690ac4b086821ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6920acd78a52abe1f72ce052d12552b2cfc7194fa5f0f9fd7690ac4b086821ed"
    sha256 cellar: :any_skip_relocation, ventura:        "1407a63390a8260b538484448c2262aed7c5391f4ba4bc032b9e66085079fd31"
    sha256 cellar: :any_skip_relocation, monterey:       "1407a63390a8260b538484448c2262aed7c5391f4ba4bc032b9e66085079fd31"
    sha256 cellar: :any_skip_relocation, big_sur:        "1407a63390a8260b538484448c2262aed7c5391f4ba4bc032b9e66085079fd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d5d1c6a90d8135c1313484d8b0614de6382983ee41a205c2a99cf39a38ba398"
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
