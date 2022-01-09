require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.11.tgz"
  sha256 "8bf5b090eb72329d29c09c22fae5b078880b0e6e0c8361400add145c7fe2374f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255952915821d9cbed09ad1e1a5f75d338fdb404f8cf11e9b7b2b31b40837dd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "255952915821d9cbed09ad1e1a5f75d338fdb404f8cf11e9b7b2b31b40837dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "18064ae118fe7543c9c0164fd12942d08a0f0889c63095d0c8840c6e11437ba9"
    sha256 cellar: :any_skip_relocation, big_sur:        "18064ae118fe7543c9c0164fd12942d08a0f0889c63095d0c8840c6e11437ba9"
    sha256 cellar: :any_skip_relocation, catalina:       "18064ae118fe7543c9c0164fd12942d08a0f0889c63095d0c8840c6e11437ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd794210c5d77724c366754186ff03d2625499dee3da55a550a65f64060c99a"
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
