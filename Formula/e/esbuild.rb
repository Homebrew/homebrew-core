require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.19.5.tgz"
  sha256 "0c124159b04559b5db720fa74264828f50e20532ffa4a47e8d2468e526fe426c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1efd24d29f2766bad05b873ac26ab965d460a9fdd51ec2dd54c10706ae54395"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1efd24d29f2766bad05b873ac26ab965d460a9fdd51ec2dd54c10706ae54395"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1efd24d29f2766bad05b873ac26ab965d460a9fdd51ec2dd54c10706ae54395"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9f44bc5daa928298bd222244c4419946d8e62b5eb0a3186156d810874583d99"
    sha256 cellar: :any_skip_relocation, ventura:        "c9f44bc5daa928298bd222244c4419946d8e62b5eb0a3186156d810874583d99"
    sha256 cellar: :any_skip_relocation, monterey:       "c9f44bc5daa928298bd222244c4419946d8e62b5eb0a3186156d810874583d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191a5ccd8ba012d4ae9138d2e116f49d4f9d4a062fb9d8c9b819f8452e031afa"
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
