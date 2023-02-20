require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.17.10.tgz"
  sha256 "c1d357f728d73382a2535c1d4c29307e1527e514a922fca6de79eb0352a6fc9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d2a031de9abc4777bba32cf62402e631b74eac87b4ce964b691e37f486cfa91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d2a031de9abc4777bba32cf62402e631b74eac87b4ce964b691e37f486cfa91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d2a031de9abc4777bba32cf62402e631b74eac87b4ce964b691e37f486cfa91"
    sha256 cellar: :any_skip_relocation, ventura:        "79225d4f43766cfff885497631e3d304ff58be91479bc3a7bf42b90e806b96bb"
    sha256 cellar: :any_skip_relocation, monterey:       "79225d4f43766cfff885497631e3d304ff58be91479bc3a7bf42b90e806b96bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "79225d4f43766cfff885497631e3d304ff58be91479bc3a7bf42b90e806b96bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac982d0d885f7f37b6a1c3699e79018c964d26938908741d367f1b61017fb00b"
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
