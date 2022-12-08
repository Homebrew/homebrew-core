require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.2.tgz"
  sha256 "b01a0e828fdc99947134482a466ed64256af3ae6709f74036599fb74f6bd4deb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5837c12151e5c340ceca44eb5472e24e46d598e97422c5a8d25d2dfe90849924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5837c12151e5c340ceca44eb5472e24e46d598e97422c5a8d25d2dfe90849924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5837c12151e5c340ceca44eb5472e24e46d598e97422c5a8d25d2dfe90849924"
    sha256 cellar: :any_skip_relocation, ventura:        "9f0d980068285e92aa0e7c992f1c4b574db7b7db93b7cbf2dd2d9d0b377473f1"
    sha256 cellar: :any_skip_relocation, monterey:       "9f0d980068285e92aa0e7c992f1c4b574db7b7db93b7cbf2dd2d9d0b377473f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f0d980068285e92aa0e7c992f1c4b574db7b7db93b7cbf2dd2d9d0b377473f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5061f75eb9cc4b23139d25eaa35c47b771be68ccad93c78f5db44f33b9ad2af0"
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
