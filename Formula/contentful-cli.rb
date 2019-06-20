require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.27.0.tgz"
  sha256 "83dd533631719f50959652f805b6c08e93a9bf0dafc9cc9dedd11b47425dea15"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9722e322f6c922d980176139a1a9aac5fd4b344fff94a488806587ca6643bf93" => :mojave
    sha256 "4aa35fb719491a2966f9caee4bf5e3a8bf49d60adb678fe033b8ae1bfe4c20ac" => :high_sierra
    sha256 "73b3fde7f9b7964c24a3a783a619ff25f05c17dfb400e576729aebead3ab57ad" => :sierra
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
