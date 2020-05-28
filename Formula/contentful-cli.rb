require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.3.tgz"
  sha256 "3094e46fa703d1407282b6aae4178ecb69cb199cefd5f0c50b2eba3dd2788060"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "151461502d825819304c84091b61d6170d0a4093bf4a0341780b9f46e4e163db" => :catalina
    sha256 "fb090090d3a145e96d6c149482b9da0bd4ec9ac982b3c533c3845d722aed6d6f" => :mojave
    sha256 "c61d31f894ea14e5d091af747bdf64cca0294d5a7d6faf1e3e387ecc905a1895" => :high_sierra
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
