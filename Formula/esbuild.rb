require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.11.tgz"
  sha256 "0f457b402dcf90165cca75faf1a555670ca89ee6317ed9971e86a7a16f581c52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de2680c360e8e53a9deaecd118f20c7af3ef95ed0da03c02e648ba029473979"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3de2680c360e8e53a9deaecd118f20c7af3ef95ed0da03c02e648ba029473979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3de2680c360e8e53a9deaecd118f20c7af3ef95ed0da03c02e648ba029473979"
    sha256 cellar: :any_skip_relocation, ventura:        "b5580fced3b19b4bc2e9ded9cf85f1f6a78b6a02cdf4e42024cbf89e601eaf62"
    sha256 cellar: :any_skip_relocation, monterey:       "b5580fced3b19b4bc2e9ded9cf85f1f6a78b6a02cdf4e42024cbf89e601eaf62"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5580fced3b19b4bc2e9ded9cf85f1f6a78b6a02cdf4e42024cbf89e601eaf62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525c8f73d61419f63a3c32af0954a731f5beac4b1d88124123ed407c586937c6"
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
