require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.24.tgz"
  sha256 "fff96f425cededdb3edefd93f2f7af17dad5d9cb79980ac3fcd3ab03572f2ea7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6853ca8f03dc2ac628da9c82c103f22f8b771f8463db444a3e23e50bb309bafd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6853ca8f03dc2ac628da9c82c103f22f8b771f8463db444a3e23e50bb309bafd"
    sha256 cellar: :any_skip_relocation, monterey:       "388444731972e5edf50264f0597b5b6ab85b277768464b30f291c7868f131c85"
    sha256 cellar: :any_skip_relocation, big_sur:        "388444731972e5edf50264f0597b5b6ab85b277768464b30f291c7868f131c85"
    sha256 cellar: :any_skip_relocation, catalina:       "388444731972e5edf50264f0597b5b6ab85b277768464b30f291c7868f131c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac1102f66abf6231eddf84b5cb86d5e56d2b44561107a7fc69d457a99706105"
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
