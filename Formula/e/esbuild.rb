class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "da504f77d1856e642de6d6e96bab7ddc1da9a73726c7a67467eb4c2b7c0fdaae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7b45d1386184c83f262c1dfd4a650f8c4159994281f0c136d94249f341d5520"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7b45d1386184c83f262c1dfd4a650f8c4159994281f0c136d94249f341d5520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7b45d1386184c83f262c1dfd4a650f8c4159994281f0c136d94249f341d5520"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0fe1f83be036b0169e3df21ba9d2cf92c43d18d14f8f19f7d9df16444e5ea2e"
    sha256 cellar: :any_skip_relocation, ventura:        "c0fe1f83be036b0169e3df21ba9d2cf92c43d18d14f8f19f7d9df16444e5ea2e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0fe1f83be036b0169e3df21ba9d2cf92c43d18d14f8f19f7d9df16444e5ea2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d2211ea451ab99d01d1cff4c9cf5a4e4333fc0bcf06d821b5fde6d58bea13f"
  end

  depends_on "go" => :build
  depends_on "node" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/esbuild"
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
