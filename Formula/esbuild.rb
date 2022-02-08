require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.20.tgz"
  sha256 "998a1f9a7491838a7e4f552e315075f95c48867d435502cf70071de359f568da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13fd33139cafe554ecbd630423adeee808fa7e965c9a28acafa86ffe01c38e8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13fd33139cafe554ecbd630423adeee808fa7e965c9a28acafa86ffe01c38e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "d6783a9ff4156e7898749679ecd59efe6d212793478351538b3d54432c2ab240"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6783a9ff4156e7898749679ecd59efe6d212793478351538b3d54432c2ab240"
    sha256 cellar: :any_skip_relocation, catalina:       "d6783a9ff4156e7898749679ecd59efe6d212793478351538b3d54432c2ab240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be21b41a9a28612ee0bb0a8c71a15e45377e9e8032ecbc6a525419f89278368"
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
