require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.36.tgz"
  sha256 "c56704a0b465f31827fc3294524039dd456c8228575f0b88649e7b7b9c23468c"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5d19afac99fa6a684d017cfccf3a163686027885fd8aa755d51229d5ea0bcf1" => :catalina
    sha256 "b3639c7fb93e963332b3e7706a901d0dcbc6be1da02c0cc75c1076164fc2ff82" => :mojave
    sha256 "2c1771a04950c82dbb1d0460f617099cbcf71598806711ff6e4c55ad334b75d2" => :high_sierra
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
