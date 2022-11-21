require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.26.1.tgz"
  sha256 "74eb1a0054cbc5bc282b71c4be0ed87fc670e657fe91ab51ef2f5fc74a20ae82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81549c39549a41c3f0dbbd6260b8e965db84c715aaf93d9983c4dac028cd5057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81549c39549a41c3f0dbbd6260b8e965db84c715aaf93d9983c4dac028cd5057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81549c39549a41c3f0dbbd6260b8e965db84c715aaf93d9983c4dac028cd5057"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a4357da281c5d69264c1f9be370894fc9250ce3344e4a6758210af7904e992"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0a4357da281c5d69264c1f9be370894fc9250ce3344e4a6758210af7904e992"
    sha256 cellar: :any_skip_relocation, catalina:       "e0a4357da281c5d69264c1f9be370894fc9250ce3344e4a6758210af7904e992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9937a464ffe84b45bf2e0035ee22de81b2d9e3c0557ceb43bf54671b3065a7c9"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
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
