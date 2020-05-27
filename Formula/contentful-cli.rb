require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.1.tgz"
  sha256 "9cf6e9a0e089e7b39e2d49869f48e168894225dc612039564e6e41df13c63d48"
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
