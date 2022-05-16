require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.19.2.tgz"
  sha256 "cf20531a3a807a99863d63ea73aabe7d3054954155bc2402bf1ac18572aca817"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc0a2286e9fabe1b5b363e320f23b0c4073f8e17652722f0cf4bf8b51e14a1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc0a2286e9fabe1b5b363e320f23b0c4073f8e17652722f0cf4bf8b51e14a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "107a962302e6efafcdf685c2608aa3b34976f13f6392896b08cf0e8d58dbc6f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "107a962302e6efafcdf685c2608aa3b34976f13f6392896b08cf0e8d58dbc6f5"
    sha256 cellar: :any_skip_relocation, catalina:       "107a962302e6efafcdf685c2608aa3b34976f13f6392896b08cf0e8d58dbc6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9f0b0f339f41284713a121ca95c11140ba1ae633c16e09dcfebbef61b9f571"
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
