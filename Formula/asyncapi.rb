require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.27.3.tgz"
  sha256 "b2bb15e8c791a5ca2bd4cc9973b2c0aadbd2e52f3c731c5576124de57e8a4c59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e924a4cdd153ff6bff7bcac943c9445d147dac90a4390574e5bddb7b2938f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e924a4cdd153ff6bff7bcac943c9445d147dac90a4390574e5bddb7b2938f95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e924a4cdd153ff6bff7bcac943c9445d147dac90a4390574e5bddb7b2938f95"
    sha256 cellar: :any_skip_relocation, ventura:        "21fe48e71dc71ed67ea7d3f82af259bddf4ae3445e4330a60478287760c01b06"
    sha256 cellar: :any_skip_relocation, monterey:       "21fe48e71dc71ed67ea7d3f82af259bddf4ae3445e4330a60478287760c01b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "21fe48e71dc71ed67ea7d3f82af259bddf4ae3445e4330a60478287760c01b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "220aef446b786b9c71956485831f572229603635c56b9892486110df4177c8ff"
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
