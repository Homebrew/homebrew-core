require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.3.tgz"
  sha256 "34d7e0ef89ada960978ef6ecfcbb6c5a8988a3b873fbf5181860de8f9b490f89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fad0e87a7e887d85258536a7ffcc2c95a6f2cf30acc5345cdfd26d1750431d44"
    sha256 cellar: :any,                 arm64_ventura:  "fad0e87a7e887d85258536a7ffcc2c95a6f2cf30acc5345cdfd26d1750431d44"
    sha256 cellar: :any,                 arm64_monterey: "fad0e87a7e887d85258536a7ffcc2c95a6f2cf30acc5345cdfd26d1750431d44"
    sha256 cellar: :any,                 sonoma:         "38d2407da7195fd5f2d00e0efcd40c34c7b19fb945005277c57e1595b8bdfb84"
    sha256 cellar: :any,                 ventura:        "38d2407da7195fd5f2d00e0efcd40c34c7b19fb945005277c57e1595b8bdfb84"
    sha256 cellar: :any,                 monterey:       "38d2407da7195fd5f2d00e0efcd40c34c7b19fb945005277c57e1595b8bdfb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670dce5611655d6e75dcc838c37416ab0c1a64c0c91172960086a6ad64fe5ec4"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
