require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.6.tgz"
  sha256 "7e4a1980e56e785a992d77503de6f856b38349046cb62f89dad49c6b86fe1b07"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ead61b8eb3b093f2dd0136cce9d23c4fbd4c93b9f0b740c750da62589b54f954" => :catalina
    sha256 "ef982b0a51d65a4483bc36a8425fe2a993d47ee61750fde602ceab5005d88174" => :mojave
    sha256 "8ea8fdb902b01256e7e3d977aa676495287fa4ddda0c9cf73fb78305e980a7ea" => :high_sierra
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
