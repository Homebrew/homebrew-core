require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.12.25.tgz"
  sha256 "e0592e036ee5d9fede6609284f0f11bad23bcdd593751c31699dd8aa35d27c76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6500b34acb7573d2b7d2d8b9ea70c483fb9409c11fee8219b878ce98f64d2bd2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec6317e28cd64f3939c922012dc746e5d97ab470495533bec2fe3f68496df903"
    sha256 cellar: :any_skip_relocation, catalina:      "ec6317e28cd64f3939c922012dc746e5d97ab470495533bec2fe3f68496df903"
    sha256 cellar: :any_skip_relocation, mojave:        "ec6317e28cd64f3939c922012dc746e5d97ab470495533bec2fe3f68496df903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89d24f1a9a590c22a73fd04a2e483df95f464f057c3682ee8fc58e133660210f"
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
