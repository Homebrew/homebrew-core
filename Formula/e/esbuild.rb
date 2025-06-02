class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "c9e48734d65ca4f444618d843a1f7efc597fa18f2ad524cf9ad3ba5ab782b0e0"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41e72d852f95924c933565e25d16b10282cc71c01926b01b97fc38e15c6f1331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e72d852f95924c933565e25d16b10282cc71c01926b01b97fc38e15c6f1331"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41e72d852f95924c933565e25d16b10282cc71c01926b01b97fc38e15c6f1331"
    sha256 cellar: :any_skip_relocation, sonoma:        "1530ff03df4daf6334bd94dce0e463bb50e09619c38d43cb33cf46985aa35f5d"
    sha256 cellar: :any_skip_relocation, ventura:       "1530ff03df4daf6334bd94dce0e463bb50e09619c38d43cb33cf46985aa35f5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f56444c31ca36dd58dc7e2c66498973ce32680bb268bfd375b6b74926a1b65e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e83b42c3c2b395cf33fd596f9d35543f66f441b279a19b43462a6392dc06079"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
  end

  test do
    (testpath/"app.jsx").write <<~JS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
      process.exit()
    JS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
