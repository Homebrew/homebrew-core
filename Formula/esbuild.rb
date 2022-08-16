require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.3.tgz"
  sha256 "dbeca25348b51f9148499c4b69ac208b257179551b2019540f7d2a8c0f74556d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd413910c97c2dc7263f2b3c51aeded10852fcc23cc67fa076db7dbe125a5bb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd413910c97c2dc7263f2b3c51aeded10852fcc23cc67fa076db7dbe125a5bb0"
    sha256 cellar: :any_skip_relocation, monterey:       "26abffcda3a8cb3d95f74e6ccd0167fee706301ac64279b9f864b202b26ead16"
    sha256 cellar: :any_skip_relocation, big_sur:        "26abffcda3a8cb3d95f74e6ccd0167fee706301ac64279b9f864b202b26ead16"
    sha256 cellar: :any_skip_relocation, catalina:       "26abffcda3a8cb3d95f74e6ccd0167fee706301ac64279b9f864b202b26ead16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67b91605314ad994ed43a6321eef341a4599179a4e8f432e3bf296279e7f29f"
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
