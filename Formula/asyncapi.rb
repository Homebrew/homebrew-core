require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.17.0.tgz"
  sha256 "9209066ab7336bd641056126d9658dd410795f9bd29ef5ca5f75a2ff7487b831"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93c6de5ccde71c027ae75d827b9879ea4a79f0b34199e6dafb89989235457c6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93c6de5ccde71c027ae75d827b9879ea4a79f0b34199e6dafb89989235457c6e"
    sha256 cellar: :any_skip_relocation, monterey:       "215d6f5ecec511231f45e6563155a31bd7b2b148b48e8cc1d921cdf80fab2007"
    sha256 cellar: :any_skip_relocation, big_sur:        "215d6f5ecec511231f45e6563155a31bd7b2b148b48e8cc1d921cdf80fab2007"
    sha256 cellar: :any_skip_relocation, catalina:       "215d6f5ecec511231f45e6563155a31bd7b2b148b48e8cc1d921cdf80fab2007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6f3df99121c6f3aa87daf96ee43cba381c8a53faf5bd73ecd55c8566719bd2"
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
