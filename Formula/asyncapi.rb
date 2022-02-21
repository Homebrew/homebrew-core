require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.14.0.tgz"
  sha256 "c5cf4c4a0b0c4a9422493a3223f24394ccea0efc68cb046aecdb115ba6c14a48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f51b2ae8ae9c1041af9fe8136b3ea44f29b0fa64ba1081f69f97a3207468ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00f51b2ae8ae9c1041af9fe8136b3ea44f29b0fa64ba1081f69f97a3207468ff"
    sha256 cellar: :any_skip_relocation, monterey:       "7306bba43de47bec9a8afa4bde1648fee83ed4957c0217501f53c29fb52de455"
    sha256 cellar: :any_skip_relocation, big_sur:        "7306bba43de47bec9a8afa4bde1648fee83ed4957c0217501f53c29fb52de455"
    sha256 cellar: :any_skip_relocation, catalina:       "7306bba43de47bec9a8afa4bde1648fee83ed4957c0217501f53c29fb52de455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64adf83d66f62854dc8411887b8a16590e0cdcbd44924aa3659f48de5258b184"
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
