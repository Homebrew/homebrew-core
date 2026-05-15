class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://github.com/evanw/esbuild/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "7aae83b197db3fd695e6f378d30fd6cbddeb93e4b1057b2c41d36ecb1dfebbc2"
  license "MIT"
  head "https://github.com/evanw/esbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f62ac013c8317d78e0523e136ddaf21bd1e5165f774cc27d31ed6059ff0df855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f62ac013c8317d78e0523e136ddaf21bd1e5165f774cc27d31ed6059ff0df855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f62ac013c8317d78e0523e136ddaf21bd1e5165f774cc27d31ed6059ff0df855"
    sha256 cellar: :any_skip_relocation, sonoma:        "c64ef57deb512ce3c553ddc910cbcebe2102b5846c555d39467578037a3937cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "847f32ae2438b0afd916a011be8e2325ddf42cb2956d63c7d009b1fae3fc9207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852fa72d9edbcabb3c7174d2d6170d18817203bd978b3e0644d4aac0a951bb95"
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
