require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.2.tgz"
  sha256 "f3dd00e8b061f0104d8573113542c4e4d1486ee11e7c951a9e0c15dc27ffd36a"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d04e254de667d144415675362c9fd4182d72ff0194ae3952a9c5eb054a7fdd54" => :catalina
    sha256 "c6bb0b38b8390ca387145440cb43d42e3351c3caab194db93337f94441a95fd9" => :mojave
    sha256 "762258dc80390a2b18fff3842490c8058d2afe8dc5b19a6d8920e662836b25c9" => :high_sierra
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
