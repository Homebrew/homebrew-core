class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "21b713a3a0a9febc6fae5988ad288c4684f38c11fa585acd3678ba3ee6891824"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2eb78bb1034069fbcbc3b7625e4c91c7f350d1657063463b30e36db9e801066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2eb78bb1034069fbcbc3b7625e4c91c7f350d1657063463b30e36db9e801066"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2eb78bb1034069fbcbc3b7625e4c91c7f350d1657063463b30e36db9e801066"
    sha256 cellar: :any_skip_relocation, sonoma:        "c59ac318bd27fb81a92dd7fe1b53a3c5c798591872e51376ce1d97a4a65735db"
    sha256 cellar: :any_skip_relocation, ventura:       "c59ac318bd27fb81a92dd7fe1b53a3c5c798591872e51376ce1d97a4a65735db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "579c5d97429159cae5e772177446f0fecb896174516ed71c484f4e013292b50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db9fa1d0fa161ef3d3cd3d4471243ce939109a239123750a2c40a99964f8af4"
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
