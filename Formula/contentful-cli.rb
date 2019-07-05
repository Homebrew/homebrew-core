require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.33.2.tgz"
  sha256 "a55f3faafe72990ff7445284c3c795f1e441cca0de4c32f868e3643ed9384978"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c39fe2a592157a84181bf124f6f8255db243ffdbf13866c649ca7f7731b5d19" => :mojave
    sha256 "abb221a2c8c86811dc8de0406b3634db818131a8358962224e3618b967a1c3ed" => :high_sierra
    sha256 "bf8d87a2289199eb3c4736a2ec0e7ef47620de9e14cc2542a2bdd69105243bb1" => :sierra
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
