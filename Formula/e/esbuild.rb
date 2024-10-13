class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "db289a2d668e42f81b93d7489c27ef665e86ef4e5c4974997526d46982f2b68a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe0a47b1f1a4573fa5bc5955418a778e4255f869d6b9de95c207533e4e24b515"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0a47b1f1a4573fa5bc5955418a778e4255f869d6b9de95c207533e4e24b515"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe0a47b1f1a4573fa5bc5955418a778e4255f869d6b9de95c207533e4e24b515"
    sha256 cellar: :any_skip_relocation, sonoma:        "c84a7d059a4001db54eb4c45d3f955cf86167657192ac45d67110e20ff5f0e96"
    sha256 cellar: :any_skip_relocation, ventura:       "c84a7d059a4001db54eb4c45d3f955cf86167657192ac45d67110e20ff5f0e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c11fa0f62044d1a166acd2f5c393463ea5e557d5c12a5937b685e0785656056"
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
