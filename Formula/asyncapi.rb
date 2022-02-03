require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.11.2.tgz"
  sha256 "75e4d0e73f0ea8693ccfa684c3fd5ca26cab4f4a634c9064b90520093df882bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7750de3e8586fc9e2731d6d5d2aeab44b542b6d96d89a83644b1dd64f057f21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7750de3e8586fc9e2731d6d5d2aeab44b542b6d96d89a83644b1dd64f057f21"
    sha256 cellar: :any_skip_relocation, monterey:       "e11d112a33d6217b3f57b6c445a55a4dc88b7de89bb7cfc61314da5fd29baced"
    sha256 cellar: :any_skip_relocation, big_sur:        "e11d112a33d6217b3f57b6c445a55a4dc88b7de89bb7cfc61314da5fd29baced"
    sha256 cellar: :any_skip_relocation, catalina:       "e11d112a33d6217b3f57b6c445a55a4dc88b7de89bb7cfc61314da5fd29baced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5150b5399c5ee76f282eb9c836a5ec0d364aff177dfe9450dcaecc420a2cf590"
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
