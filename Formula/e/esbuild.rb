class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "d16527a0b29c747d80afaa1cd362d7eee5814c0569af6cc2080e7343482b28d2"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef2a77489c1e3208b4d60c0acd23b1ce015365848f1dc74e8fef27d921324334"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2a77489c1e3208b4d60c0acd23b1ce015365848f1dc74e8fef27d921324334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2a77489c1e3208b4d60c0acd23b1ce015365848f1dc74e8fef27d921324334"
    sha256 cellar: :any_skip_relocation, sonoma:        "d05eda7608e16a581221fb75b43405b9ad23774034ce9fc85606b63b7bb45ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a50194e6516e1bc09b436702de8b7aff071dec8ae8a1b59f3e783dbff4c683b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813d735b86219759c1bd5d44a723e55b9418977b0d25e521ccee3f0473846459"
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
