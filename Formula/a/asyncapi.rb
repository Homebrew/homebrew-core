require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.7.tgz"
  sha256 "f8888003385ed6a9726f7116bb4c66b63db791482858e9af2433e9dbc4183080"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91fb7b26f3be5e433cee2643662db2f9a42edb64ca1a62b8246e492e7410edd8"
    sha256 cellar: :any,                 arm64_ventura:  "91fb7b26f3be5e433cee2643662db2f9a42edb64ca1a62b8246e492e7410edd8"
    sha256 cellar: :any,                 arm64_monterey: "91fb7b26f3be5e433cee2643662db2f9a42edb64ca1a62b8246e492e7410edd8"
    sha256 cellar: :any,                 sonoma:         "d10660d7230bde69b83b46852e60dd6d02cbc30be6501c6f7798792701ee879c"
    sha256 cellar: :any,                 ventura:        "d10660d7230bde69b83b46852e60dd6d02cbc30be6501c6f7798792701ee879c"
    sha256 cellar: :any,                 monterey:       "d10660d7230bde69b83b46852e60dd6d02cbc30be6501c6f7798792701ee879c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f430781dd083d774d6ea7b5d1c2c5130ba9bc4e3a2833e5ae4ae6781648a1fe5"
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
