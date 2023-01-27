require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.5.tgz"
  sha256 "ec7c20405598c29083713e661dacb32d42b4c60e57548445f97e8affd9281b4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "194550d9b7de5cd2315efbb88005623a86e28f366bfbff4e9b9ecdd83cbd3b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "194550d9b7de5cd2315efbb88005623a86e28f366bfbff4e9b9ecdd83cbd3b99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "194550d9b7de5cd2315efbb88005623a86e28f366bfbff4e9b9ecdd83cbd3b99"
    sha256 cellar: :any_skip_relocation, ventura:        "5681c6480f18395334b9a8eca07f5fe26b5252535d4d8179cb9292087f603f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "5681c6480f18395334b9a8eca07f5fe26b5252535d4d8179cb9292087f603f7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5681c6480f18395334b9a8eca07f5fe26b5252535d4d8179cb9292087f603f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09987e6bae10433924022e2d7cb2b761e896d599afb85a3e202d5d7400ad01b2"
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
