class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a4fd2af11353d41999b51bfa4276cbdd562b5f5fc19b3ca56ab69a520b176529"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0e1d98b2254243b60b91e2f18618eb5913ae7dadba4492c4fdecd79c5441f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0e1d98b2254243b60b91e2f18618eb5913ae7dadba4492c4fdecd79c5441f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e1d98b2254243b60b91e2f18618eb5913ae7dadba4492c4fdecd79c5441f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "b32de09c5fe1419f682b758af178dddc0a93a3be00efde7d80b25a82c21dfca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c935ee97e4dc9444f370a21e243ae05013b5381816cf1d0a33e522646c4c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ad72aea3cfe024a41a33c552a5ca9db9f8c657be714757e264abd765176033"
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
