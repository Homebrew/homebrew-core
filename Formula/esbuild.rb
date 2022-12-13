require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.16.5.tgz"
  sha256 "cc4350951fc757258c4122f7c243903b33a607eddb5499a6e173725e70758e99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2db1ca1a1c7223380c99f93ba936f7b0a86d3d29c3ec7363ff75276166d30b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2db1ca1a1c7223380c99f93ba936f7b0a86d3d29c3ec7363ff75276166d30b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2db1ca1a1c7223380c99f93ba936f7b0a86d3d29c3ec7363ff75276166d30b6"
    sha256 cellar: :any_skip_relocation, ventura:        "8e5593843b64ba900ce907c4ad49a7831ee99b63124876094ef791c749e983c8"
    sha256 cellar: :any_skip_relocation, monterey:       "8e5593843b64ba900ce907c4ad49a7831ee99b63124876094ef791c749e983c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e5593843b64ba900ce907c4ad49a7831ee99b63124876094ef791c749e983c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e717ddac4061565c928ab93f6ad71107c9c5371d3bf5c809de4302679e27b207"
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
