require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.2.tgz"
  sha256 "eb9f30654abbfdfd7122dfd435bdef5e82fa282f67efd3cc23db0165e0ba1d07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "621f85b16f7c83682e458ec694a36f0a79317ce1c7ff501eb73396f4b71c87c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621f85b16f7c83682e458ec694a36f0a79317ce1c7ff501eb73396f4b71c87c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621f85b16f7c83682e458ec694a36f0a79317ce1c7ff501eb73396f4b71c87c8"
    sha256 cellar: :any_skip_relocation, ventura:        "cef846ae444da054fdf867fcfbdb8b93681a91c54e8072e406eccb20ab153559"
    sha256 cellar: :any_skip_relocation, monterey:       "cef846ae444da054fdf867fcfbdb8b93681a91c54e8072e406eccb20ab153559"
    sha256 cellar: :any_skip_relocation, big_sur:        "cef846ae444da054fdf867fcfbdb8b93681a91c54e8072e406eccb20ab153559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c20ec6028ac8096ae3543a7a8d16dab99a5d31dd3c2148df626498fbac95ea"
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
