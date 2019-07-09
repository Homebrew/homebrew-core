require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.34.0.tgz"
  sha256 "60963e06803cbe13fcf2203dc5aa34509441f722197e15671d4baa0edfc76cd9"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2119c97ae3d71e78354e0dd1fef5853023519c9879fe5bd0e8fe5993eb164bb4" => :mojave
    sha256 "ab546b1842657670074a0f3e735bd50e71d16a29d53a60c4b26c96cc1f427071" => :high_sierra
    sha256 "38c04cd937324fa3ef36b20c88c3297038eb5e1c5c66211e6374e91727d13bb4" => :sierra
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
