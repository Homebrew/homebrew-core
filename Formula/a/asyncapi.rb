require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.13.tgz"
  sha256 "7dd66177d6e5d0d6d84f0e293a3b01aa3588ee69d5c79f401ecafdf6718faec4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ece1c5078e13c3e57a25a9be4c582257431f41bd773f6d259ad2d1bca0f73a6c"
    sha256 cellar: :any,                 arm64_ventura:  "ece1c5078e13c3e57a25a9be4c582257431f41bd773f6d259ad2d1bca0f73a6c"
    sha256 cellar: :any,                 arm64_monterey: "ece1c5078e13c3e57a25a9be4c582257431f41bd773f6d259ad2d1bca0f73a6c"
    sha256 cellar: :any,                 sonoma:         "339c2f475441de01fbae59060fd58af83539bc498e4192a66c33c6d6fcf5c5d2"
    sha256 cellar: :any,                 ventura:        "339c2f475441de01fbae59060fd58af83539bc498e4192a66c33c6d6fcf5c5d2"
    sha256 cellar: :any,                 monterey:       "339c2f475441de01fbae59060fd58af83539bc498e4192a66c33c6d6fcf5c5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0443c434e02f0d76ac3e53fdd3f603eb1f617e731790e4d1cd9600be51090158"
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
