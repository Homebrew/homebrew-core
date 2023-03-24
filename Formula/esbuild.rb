require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.13.tgz"
  sha256 "dbe44a6524a1b0ecb07caf5e7ba6cf00148dc26c76ee4ae076f79e31d2ce16e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c44ec350b481e932333f881bdb4bc608ed529cec4642e81ca9c48adc36ae92e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c44ec350b481e932333f881bdb4bc608ed529cec4642e81ca9c48adc36ae92e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c44ec350b481e932333f881bdb4bc608ed529cec4642e81ca9c48adc36ae92e5"
    sha256 cellar: :any_skip_relocation, ventura:        "1474493924aa4c3aadb4b639dcf9b8a9eb7101b338e715169b200ff43274fb98"
    sha256 cellar: :any_skip_relocation, monterey:       "1474493924aa4c3aadb4b639dcf9b8a9eb7101b338e715169b200ff43274fb98"
    sha256 cellar: :any_skip_relocation, big_sur:        "1474493924aa4c3aadb4b639dcf9b8a9eb7101b338e715169b200ff43274fb98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae37dc01004aaf9ffc30cec2ea02303d468bb04eb466b4c643ccb5df2679f250"
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
