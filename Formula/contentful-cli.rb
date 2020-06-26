require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.16.tgz"
  sha256 "0cf449da78cc44e3629d93cc8dbe7e9ffe756fafffae07a7c100c2c4dd9ba196"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd3fb8c78697cbbb39e293eacdc0fa9b8cc0edc04d1b908b6559c006221fc0ad" => :catalina
    sha256 "0dd7334e1711b51207ab4791dbaa0e6bb1267c1c81b48796c80a2745a298dd68" => :mojave
    sha256 "c61bf609e56ffd80fffd896ef2999f1acf9aa2c860b89ab957432c59f08c7d9c" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
