require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.16.0.tgz"
  sha256 "01f2eaf5cee02db2cf6494a70c46d7063c41db34797475ff3ceb98e024c36ff8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b19dc647b957dc3bbe8028b495ac1fc3391c6ca6e3f28c8f594842b7a5bca9f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b19dc647b957dc3bbe8028b495ac1fc3391c6ca6e3f28c8f594842b7a5bca9f0"
    sha256 cellar: :any_skip_relocation, monterey:       "f21d39fa06ab1917d82c294ac06b06253ba79180732cb7b6ef62aaa2ef924093"
    sha256 cellar: :any_skip_relocation, big_sur:        "f21d39fa06ab1917d82c294ac06b06253ba79180732cb7b6ef62aaa2ef924093"
    sha256 cellar: :any_skip_relocation, catalina:       "f21d39fa06ab1917d82c294ac06b06253ba79180732cb7b6ef62aaa2ef924093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc76aa8507a9316c5c389c01473f9cb8ca6e51397f71ed3f4b333ec7bddb98e5"
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
