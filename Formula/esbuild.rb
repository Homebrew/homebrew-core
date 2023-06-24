require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.18.7.tgz"
  sha256 "eebb3d2312a7c9f7c0f729602c253b565459bfb28616b446de4e8cbe17374e35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d12534f6910ba646a44e81e45eb97f0df661cbb5fd10973459050f44dfada916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d12534f6910ba646a44e81e45eb97f0df661cbb5fd10973459050f44dfada916"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d12534f6910ba646a44e81e45eb97f0df661cbb5fd10973459050f44dfada916"
    sha256 cellar: :any_skip_relocation, ventura:        "a591754f330ee81fc2f0977dd7df5c453284f8733916529b6ec5fd2a3fd4ff12"
    sha256 cellar: :any_skip_relocation, monterey:       "a591754f330ee81fc2f0977dd7df5c453284f8733916529b6ec5fd2a3fd4ff12"
    sha256 cellar: :any_skip_relocation, big_sur:        "a591754f330ee81fc2f0977dd7df5c453284f8733916529b6ec5fd2a3fd4ff12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982459edf67240a4ebd7073381193d328251a15748ab3c532fb269f697d47cda"
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
