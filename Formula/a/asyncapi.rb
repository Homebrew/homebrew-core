require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.7.0.tgz"
  sha256 "9ead413bb8768446d3d3a5c7b3ea2547cb662a83e6e13ddab4e14c8d1329fe75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d9c38085a5b71e0488fac467e3e5c34bbdcffdf08524523ea1924687d828125"
    sha256 cellar: :any,                 arm64_ventura:  "9d9c38085a5b71e0488fac467e3e5c34bbdcffdf08524523ea1924687d828125"
    sha256 cellar: :any,                 arm64_monterey: "dc1cb8c85b12c975f721d9a75ff42d57e02e4d058a84ba8fdf7996e44df78720"
    sha256 cellar: :any,                 sonoma:         "f393df278811593b279e1ab04f27162a2311c56cfc8665dfdec053e81070c5a4"
    sha256 cellar: :any,                 ventura:        "f393df278811593b279e1ab04f27162a2311c56cfc8665dfdec053e81070c5a4"
    sha256 cellar: :any,                 monterey:       "f393df278811593b279e1ab04f27162a2311c56cfc8665dfdec053e81070c5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e627cec0ca5b2810251c4dc7d26d0f14d3f2d1f987e86c4a23379db49426a0cb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
