require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.17.tgz"
  sha256 "6b87aa42fbed64fe9e1b634ee8ad2da39f67a6a52ab2cda07b1973b69b026fc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c067b02feb3b2ef39066aa987efb66076248bb5693a7985dddf90a5cea203e19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c067b02feb3b2ef39066aa987efb66076248bb5693a7985dddf90a5cea203e19"
    sha256 cellar: :any_skip_relocation, monterey:       "6376eb3be3074cdc89ff78cc8ec34f919b7dd0a78a76c75ad4a26f4c17960a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6376eb3be3074cdc89ff78cc8ec34f919b7dd0a78a76c75ad4a26f4c17960a7b"
    sha256 cellar: :any_skip_relocation, catalina:       "6376eb3be3074cdc89ff78cc8ec34f919b7dd0a78a76c75ad4a26f4c17960a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb95719a80516f9b651518cd28e48a74224910514b89c36ef668d36c2eb210d"
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
