require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.13.2.tgz"
  sha256 "c9c6064f3a144b8a9ed6bce51443d5079cc65aa9e7da1bf659c48dae59ed168d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64436bc0bab5318aee14d636021044ae7993ba395d05309e29f6039161c3aae9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64436bc0bab5318aee14d636021044ae7993ba395d05309e29f6039161c3aae9"
    sha256 cellar: :any_skip_relocation, monterey:       "52217d857d9752ec2e88be7a85fb18b05c81484dd379b06bc1dcd34faff4bd46"
    sha256 cellar: :any_skip_relocation, big_sur:        "52217d857d9752ec2e88be7a85fb18b05c81484dd379b06bc1dcd34faff4bd46"
    sha256 cellar: :any_skip_relocation, catalina:       "52217d857d9752ec2e88be7a85fb18b05c81484dd379b06bc1dcd34faff4bd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e8329ec4b6e5be85df5494d640334ed5862b9aa23a36cfaf202d787cfac594"
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
