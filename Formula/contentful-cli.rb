require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.7.tgz"
  sha256 "d0ed4d0ed17d7c79f6c9f7e75ea28b267e1d8a3f065354f175edde42fd3ea6c9"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b3681093134e157685fccbf36849dc3a50da935e0d463f90cfe8dbd0740e972" => :catalina
    sha256 "3103016339e12a5a661ada3a6a09be6e4b55af65c24b3257637ed14697b02206" => :mojave
    sha256 "e614af61577758261aed05cb1ba43cbc673660c52c1eb0b5b4928211ea30a4c0" => :high_sierra
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
