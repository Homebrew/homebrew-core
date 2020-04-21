require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.18.tgz"
  sha256 "c6d96e4924e22d09b851bb00e8e92080274c63a2da03e96f0dc4f2a875930a8b"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4a50b16b7cde0f6121ebd2ceb7cb8c1f06eff0196c511bb98aff3eaec598e54" => :catalina
    sha256 "805e8603a44866b7c159a0abcb3a365e53b6e55475525a63aa7ec8778a9e35cf" => :mojave
    sha256 "20446f3a03b020669bef39c5982d0c0a7e5462bd02ed045186097e022e34e6fd" => :high_sierra
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
